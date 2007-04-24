class SearchExtension < Radiant::Extension
  version "0.1"
  description "Provides a page type that allows you to search for pages in Radiant.  Based on Oliver Baltzer's search_behavior."
  url "http://dev.radiantcms.org/svn/radiant/branches/mental/extensions/search/"

  # define_routes do |map|
  #   map.connect 'admin/search/:action', :controller => 'admin/asset'
  # end
  
  def activate
    # admin.tabs.add "Search", "/admin/search", :after => "Layouts", :visibility => [:all]
    SearchPage
  end
  
  def deactivate
    # admin.tabs.remove "Search"
  end
    
end