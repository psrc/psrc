# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class FuzzyBearsExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/fuzzy_bears"
  
  define_routes do |map|
    map.connect '/admin/fuzzy_bears/:action', :controller => 'fuzzy_bears'
  end
  
  def activate
    admin.tabs.add "Fuzzy Bears", "/admin/fuzzy_bears", :after => "Layouts", :visibility => [:all]
    Page.send :include, FuzzyBearTags
  end
  
  def deactivate
    admin.tabs.remove "Fuzzy Bears"
  end
  
end