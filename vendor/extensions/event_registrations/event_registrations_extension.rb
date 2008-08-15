# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class EventRegistrationsExtension < Radiant::Extension
  version "1.0"
  description "Lets admin users create events, and lets people register for them."
  url "http://fixieconsulting.com"
  
   define_routes do |map|
     map.with_options(:name_prefix => 'admin_', :path_prefix => 'admin', :namespace => 'admin/') do |m|
       m.resources :events
       m.resources :event_options
     end
     map.event '/event/:id', :controller => 'events', :action => 'show'
     map.start_registration 'event/:id/registrations/select-type', :controller => 'registrations', :action => 'select_type'
     map.enter_people 'event/:event_id/registrations/:event_option_id/whos-attending', :controller => 'registrations', :action => 'whos_attending'
     map.registration_contact 'event/:event_id/registrations/:event_option_id/contact-info', :controller => 'registrations', :action => 'contact_info'
   end
  
  def activate
    admin.tabs.add "Events", "/admin/events", :before => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    admin.tabs.remove "Event Registrations"
  end
  
end
