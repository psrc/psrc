require 'radiant/extension'
require 'method_observer'

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
        ExtensionLoader.discover_extensions
        ExtensionLoader.activate_extensions
      end
    end

    include Simpleton
    
    attr_accessor :initializer, :extensions
    
    def initialize
      self.extensions = []
    end
    
    def configuration
      initializer.configuration
    end
    
    def load_paths
      load_extension_roots.map { |root| load_paths_for(root) }.flatten.select { |d| File.directory?(d) }
    end

    def plugin_paths
      load_extension_roots.map {|root| "#{root}/vendor/plugins" }.select {|d| File.directory?(d) }
    end
    
    def add_load_and_plugin_paths
      load_paths.reverse_each do |path|
        configuration.load_paths.unshift path
      end
      configuration.plugin_paths.concat plugin_paths
    end

    def controller_paths
      extensions.map { |extension| "#{extension.root}/app/controllers" }.select { |d| File.directory?(d) }
    end
    
    def add_controller_paths
      configuration.controller_paths.concat(controller_paths)
    end
    
    def view_paths
      extensions.map { |extension| "#{extension.root}/app/views" }.select { |d| File.directory?(d) }
    end
    
    # Load the extensions
    def discover_extensions
      @observer ||= DependenciesObserver.new(configuration).observe(::Dependencies)
      self.extensions = load_extension_roots.map do |root|
        begin
          extension_file = "#{File.basename(root).sub(/^\d+_/,'')}_extension"
          extension = extension_file.camelize.constantize
          extension.unloadable
          extension.root = root
          extension
        rescue LoadError, NameError => e
          $stderr.puts "Could not load extension from file: #{extension_file}.\n#{e.inspect}"
          nil
        end
      end.compact
    end
    
    def deactivate_extensions
      extensions.each { |extension| extension.deactivate }
    end
    
    def activate_extensions
      initializer.initialize_default_admin_tabs
      # Reset the view paths after 
      initializer.initialize_framework_views
      extensions.each { |extension| extension.activate }
    end
    alias :reactivate :activate_extensions

    private

      def load_paths_for(ext_path)
        load_paths = %w(lib app/models app/controllers app/helpers test/helpers).collect { |p| "#{ext_path}/#{p}" }
        load_paths << ext_path          
        load_paths.select { |d| File.directory?(d) }
      end
      
      def load_extension_roots
        if configuration.extensions.is_a?(Array) && !configuration.extensions.empty?
          @load_extension_roots ||= select_extension_roots
        else
          []
        end
      end
      
      def select_extension_roots
        # put in the paths for extensions into the array
        roots = configuration.extensions.map do |ext_name|
          if :all === ext_name
            :all
          else
            ext_path = all_extension_roots.detect do |maybe_path|
              File.basename(maybe_path) =~ /^(\d+_)?#{ext_name}/
            end
            raise(LoadError, "Cannot find the extension '#{ext_name}'!") if ext_path.nil?
            all_extension_roots.delete(ext_path)
          end
        end
        # replace the :all symbol with any remaining paths
        roots.map do |ext_path|
          :all === ext_path ? all_extension_roots : ext_path
        end.flatten
      end
      
      def all_extension_roots
        @all_extension_roots ||= configuration.extension_paths.map do |path|
          Dir["#{path}/*"].map {|f| File.directory?(f) ? File.expand_path(f) : nil}.compact.sort
        end.flatten
      end
  end
end
