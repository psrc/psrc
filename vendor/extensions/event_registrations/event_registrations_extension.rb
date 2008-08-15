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
     map.options 'event/:id/registrations/options', :controller => 'registrations', :action => 'options'
     map.attendee_info 'event/:event_id/registrations/:event_option_id/attendee-info', :controller => 'registrations', :action => 'attendee_info'
     map.contact_info 'event/:event_id/registrations/:event_option_id/contact-info', :controller => 'registrations', :action => 'contact_info'
     map.payment 'event/:event_id/registrations/:event_option_id/payment', :controller => 'registrations', :action => 'payment'
     map.confirmation 'event/:event_id/registrations/:event_option_id/confirmation', :controller => 'registrations', :action => 'confirmation'
   end
  
  def activate
    admin.tabs.add "Events", "/admin/events", :before => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    admin.tabs.remove "Event Registrations"
  end
  
end
