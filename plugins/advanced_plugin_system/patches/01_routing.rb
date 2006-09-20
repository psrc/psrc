require 'action_controller/routing'

module PluginRouteSetExtension
  
  def self.included(base)
    base.class_eval do
      alias :draw_without_plugin_routes :draw
      alias :draw :draw_with_plugin_routes
    end
  end
  
  def draw_with_plugin_routes
    draw_without_plugin_routes do
      add_plugin_routes
      yield self
    end
  end

  private
  
    def add_plugin_routes
      Plugin.registered.values.each do |plugin|
        #if plugin.active?
        plugin.route_definitions.each do |block|
          block.call(self)
        end
        #end
      end
    end
end

ActionController::Routing::RouteSet.class_eval do
  include PluginRouteSetExtension
end