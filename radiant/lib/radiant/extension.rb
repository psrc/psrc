require 'annotatable'
require 'simpleton'
require 'radiant/admin_ui'

module Radiant
  class Extension
    include Simpleton
    include Annotatable

    annotate :version, :description, :url, :root, :extension_name
    
    attr_writer :active
    
    def active?
      @active
    end
      
    def enabled?
      meta.enabled?
    end
    
    def migrator
      ExtensionMigrator.new(self)
    end
  
    def admin
      AdminUI.instance
    end
  
    def meta
      self.class.meta
    end
    
    class << self

      def activate_extension
        return if instance.active?
        load_plugins
        instance.activate if instance.respond_to? :activate
        ActionController::Routing::Routes.reload
        instance.active = true
      end
      alias :activate :activate_extension
      
      def deactivate_extension
        return unless instance.active?
        instance.active = false
        instance.deactivate if instance.respond_to? :deactivate
      end
      alias :deactivate :deactivate_extension
      
      def enable(enabled = true)
        deactivate_extension if active?
        meta.update_attribute(:enabled, enabled)
        activate_extension if enabled
        enabled
      end
      alias :enabled= :enable
      
      def define_routes(&block)
        route_definitions << block
      end
      
      def inherited(subclass)
        subclass.extension_name = subclass.name.to_name('Extension')
      end
      
      def meta
        Radiant::ExtensionMeta.find_or_create_by_name(extension_name)
      end
      
      def route_definitions
        @route_definitions ||= []
      end
      
      def load_plugins
        plugins = Dir[self.root + "/vendor/plugins/*"].select{|path| File.directory?(path)}
        plugins.each do |plugin|
          const_name = "PLUGIN_#{File.basename(plugin).upcase}"
          begin
            Radiant::Extension.const_get(const_name)
          rescue
            $LOAD_PATH << "#{plugin}/lib"
            require "#{plugin}/init.rb"
            Radiant::Extension.const_set const_name, plugin
          end
        end
      end
    end
  end
end