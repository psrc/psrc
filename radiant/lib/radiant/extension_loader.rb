require 'radiant/extension'

module Radiant
  class ExtensionLoader
    
    class DependenciesObserver < MethodObserver
      attr_accessor :config
      
      def initialize(rails_config)
        @config = rails_config
      end
      
      def before_clear(*args)
        ExtensionLoader.deactivate_extensions
      end
      
      def after_clear(*args)
        ExtensionLoader.activate_extensions
      end
    end

    include Simpleton
    
    attr_accessor :initializer
    
    def initialize
      @extension_roots = []
    end

    def configuration
      initializer.configuration
    end
    
    def initializer=(initializer)
      @initializer = initializer
    end
    
    def run
      DependenciesObserver.new(configuration).observe(Dependencies)
      
      discover_extensions
      activate_extensions
    end
    
    def discover_extensions
      all_extension_roots = configuration.extension_paths.collect do |path|
        Dir.glob("#{path}/*").sort.select { |f| File.directory?(f) }.collect do |ext_path|
          ext_path = File.expand_path(ext_path)
        end
      end.flatten
      if configuration.extensions
        #put in the paths for extensions into the array
        extension_roots = configuration.extensions.map do |ext_name|
          if :all === ext_name
            :all
          else
            ext_name = ext_name.to_s
            ext_path = all_extension_roots.detect do |maybe_path|
              File.basename(maybe_path).sub(/^\d+_/,'') == ext_name
            end
            raise(LoadError, "Cannot find the extension '#{ext_name}'!") if ext_path.nil?
            all_extension_roots.delete(ext_path)
            ext_path
          end
        end
        #replace the :all symbol with any remaining paths
        extension_roots.map! do |ext_path|
          if :all === ext_path
            all_extension_roots
          else
            ext_path
          end
        end
        extension_roots.flatten!
      else
        extension_roots = all_extension_roots
      end
      extension_roots.each do |ext_path|
          load_paths = %w(lib app/models app/controllers app/helpers test/helpers).collect { |p| "#{ext_path}/#{p}" }
          load_paths << ext_path
          load_paths.each { |p| configuration.load_paths << p; $LOAD_PATH << p; }
          configuration.controller_paths << "#{ext_path}/app/controllers"
          configuration.view_paths << "#{ext_path}/app/views"
          @extension_roots << ext_path
      end
      initializer.set_autoload_paths
      initializer.initialize_view_paths
      extension_roots
    end
    
    def deactivate_extensions
      Extension.descendants.each { |extension| deactivate(extension) }
    end
    
    def activate_extensions(enabled_extensions = nil)
      initializer.initialize_default_admin_tabs
      activated_extensions = @extension_roots.select do |root|
        extension_file = "#{File.basename(root).sub(/^\d+_/,'')}_extension"
        extension = extension_file.camelize.constantize
        extension.root = root
        extension.unloadable
        if enabled_extensions
          enabled = enabled_extensions.include?(extension.extension_name) || enabled_extensions.include?(extension)
          enable(extension, enabled)
        else
          activate(extension)
        end
      end
      initializer.initialize_routing
      activated_extensions
    end
    alias :reactivate :activate_extensions
    
    private
    
      def activate(extension)
        if extension.enabled?
          extension.activate
          extension
        end
      end
      
      def deactivate(extension)
        if extension.active?
          extension.deactivate
          extension
        end
      end
      
      def enable(extension, enabled)
        extension.enable(enabled)
        extension if enabled
      end
      
  end
end
