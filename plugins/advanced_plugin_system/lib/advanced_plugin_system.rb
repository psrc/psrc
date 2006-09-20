require 'plugin'

class AdvancedPluginSystem < Plugin::Base

  register 'Advanced Plugin System'

  version '0.1'

  description %{
    Allows plugins to create additional controllers, views, and models. It also
    provides hooks to make it easier to modify the administrative interface.
  }
  
  url 'http://dev.radiantcms.org/radiant/browser/trunk/plugins/advanced_plugin_system/README'

  define_routes do |map|
    map.plugins 'admin/plugins/:action', :controller => 'admin/plugin'
  end
  
  def activate
    admin.tabs.add "Plugins", "/admin/plugins", :for => :admin
  end

end