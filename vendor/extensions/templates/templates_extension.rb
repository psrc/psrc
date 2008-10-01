# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class TemplatesExtension < Radiant::Extension
  version "1.0"
  description "Creates a controller for testing out CMS templates"
  url "http://www.fixieconsulting.com"
  
  define_routes do |map|
    map.with_options(:controller => 'admin/templates') do |m|
      m.templates 'admin/templates', :action => 'index'
      m.front  'admin/templates/front', :action => 'front'
      m.one_col  'admin/templates/one-col', :action => 'one_col'
      m.one_col_with_nav  'admin/templates/one-col-with-nav', :action => 'one_col_with_nav'      
      m.two_col_with_nav  'admin/templates/two-col-with-nav', :action => 'two_col_with_nav'
      m.three_col_with_nav  'admin/templates/three-col-with-nav', :action => 'three_col_with_nav'
      m.two_col_halves  'admin/templates/two-col-halves', :action => 'two_col_halves'
      m.two_col_two_thirds  'admin/templates/two-col-two-thirds', :action => 'two_col_two_thirds'
      m.two_col_three_fourths  'admin/templates/two-col-three-fourths', :action => 'two_col_three_fourths'
      m.three_col_thirds  'admin/templates/three-col-thirds', :action => 'three_col_thirds'
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
