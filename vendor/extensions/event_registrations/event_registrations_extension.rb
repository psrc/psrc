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
       m.resources :registrations
     end
     map.event '/event/:id', :controller => 'events', :action => 'show'
     map.with_options(:controller => 'registrations') do |m|
       m.attendee_info  'event/:event_id/registrations/:event_option_id/attendee-info',     :action => 'attendee_info'
       m.contact_info   'event/:event_id/registrations/:event_option_id/contact-info',      :action => 'contact_info'
       m.payment_by_credit_card   'event/:event_id/registrations/:event_option_id/get-credit-card',      :action => 'payment_by_credit_card'
       m.payment_by_check   'event/:event_id/registrations/:event_option_id/get-check',      :action => 'payment_by_check'
       m.poll_for_credit_card_payment   'event/:event_id/registrations/:event_option_id/poll-for-payment',      :action => 'poll_for_credit_card_payment'
       m.payment_type   'event/:event_id/registrations/:event_option_id/payment-type',      :action => 'payment_type'
       m.payment        'event/:event_id/registrations/:event_option_id/payment',           :action => 'payment'
       m.processing     'event/:event_id/registrations/:event_option_id/payment/processing',:action => 'processing'
       m.confirmation   'event/:event_id/registrations/:event_option_id/confirmation',      :action => 'confirmation'
     end
   end
  
  def activate
    admin.tabs.add "Events", "/admin/events", :before => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    admin.tabs.remove "Event Registrations"
  end
  
end

EventOption
Registration
Event
