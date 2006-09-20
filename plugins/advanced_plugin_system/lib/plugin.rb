require 'registerable'
require 'annotatable'
require 'inheritable_class_attributes'

class Plugin
  
  include Registerable
  
  class AdminUI
  
    class TabSet
    
      class Tab
        attr_accessor :name, :url, :visibility
        
        def initialize(name, url, options = {})
          @name, @url = name, url
          @visibility = [*options[:for]].compact
          @visibility = [:all] if @visibility.empty? 
        end
        
        def shown_for?(user)
          visibility.include?(:all) or
            visibility.any? { |role| user.send("#{role}?") }
        end
        
      end
    
      def initialize
        @tabs = []
      end
    
      def add(*args)
        @tabs << Tab.new(*args)
      end
      
      def remove(name)
        tab = @tabs.find { |t| t.name == name }
        @tabs.delete(tab)
      end
      
      def each
        @tabs.each { |t| yield t }
      end
      
      include Enumerable
      
    end
    
    attr_accessor :tabs
    
    def initialize
      @tabs = TabSet.new
      tabs.add "Pages", "/admin/pages"
      tabs.add "Snippets", "/admin/snippets"
      tabs.add "Layouts", "/admin/layouts", :visibility => [:admin, :developer]
    end
    
  end
  
  class Base
    
    include Annotatable
    include InheritableClassAttributes
    
    cattr_accessor :admin
    self.admin = AdminUI.new
    
    cattr_inheritable_accessor :route_definitions
    self.route_definitions = []
    
    attr_accessor :rails_config
    attr_accessor :plugin_root
    
    annotate :version, :description, :url
    
    class << self
      def define_routes(&block)
        self.route_definitions << block
      end
      
      def instance(&block)
        inst = self.class_eval { @instance ||= new }
        inst.instance_eval(&block) if block_given?
        inst
      end
      
      def init(rails_config, root)
        instance.rails_config = rails_config
        instance.plugin_root  = root
        instance do
          apply_monkey_patches
          init_load_paths
          init if respond_to? :init
        end
      end
      
      def setup
        instance do
          migrate_database
          setup if respond_to? :setup
        end
      end
      
      %w(activate deactivate).each do |method|
        define_method(method) do
          instance.send(method) if instance.respond_to? method
        end
      end
      
    end
    
    def initialize
      @route_definitions = []
    end
    
    def apply_monkey_patches
      dir = path_to('patches')
      Dir["#{dir}/*"].sort.each { |patch| require patch }
    end
    
    def init_load_paths
      ActionView::Base.template_paths << path_to('app', 'views')
      rails_config.controller_paths << path_to('app', 'controllers')
      %w(controllers models helpers behaviors filters).each do |dir|
        $LOAD_PATH.unshift path_to('app', dir)
      end
    end
    
    def migrate_databases
    end
    
    private
      
      def path_to(*dir)
        File.join(plugin_root, *dir)
      end
    
  end
end