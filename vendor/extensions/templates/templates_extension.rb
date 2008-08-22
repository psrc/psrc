# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class TemplatesExtension < Radiant::Extension
  version "1.0"
  description "Creates a controller for testing out CMS templates"
  url "http://www.fixieconsulting.com"
  
  define_routes do |map|
    map.with_options(:controller => 'admin/templates') do |m|
      m.two_col_with_nav  'admin/templates/two-col-with-nav', :action => 'two_col_with_nav'
    end
    
    map.connect 'admin/templates/:action', :controller => 'admin/templates'
  end
  
  def activate
    admin.tabs.add "Templates", "/admin/templates", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    admin.tabs.remove "Templates"
  end
  
end