# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class FixiePublisherExtension < Radiant::Extension
  version "1.0"
  description "Users can develop on a test site, and publish to a real site."
  url "http://fixieconsulting.com"

  define_routes do |map|
    if RAILS_ENV == "production"
      map.index '/admin', :controller => 'admin/events'
    else
      map.with_options(:controller => 'publisher', :name_prefix => 'admin_', :path_prefix => 'admin', :namespace => 'admin/') do |m|
        m.new_publish 'publish',      :action => 'new'
        m.publish      'do-publish',  :action => 'create'
      end
    end
  end

  def activate
    if RAILS_ENV == 'production'
      admin.tabs.remove "Pages"
      admin.tabs.remove "Layouts"
      admin.tabs.remove "Snippets"
    else
      admin.tabs.add "Publisher", "/admin/publish", :after => "Layouts", :visibility => [:admin]
    end
  end

  def deactivate
    admin.tabs.remove "Publisher"
  end

end
