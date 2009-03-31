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
       m.resources :menu_choices
     end

     map.event '/event/:id', :controller => 'events', :action => 'show'
     map.with_options(:path_prefix => 'event-registrations', :controller => 'registrations') do |m|

       m.attendee_info        'event/:event_id/registrations/:event_option_id/attendee-info',     :action => 'attendee_info',         :method => :get
       m.submit_attendee_info 'submit-attendee-info',                                             :action => 'submit_attendee_info',  :method => :post

       m.submit_contact_info   'submit-contact-info', :action => 'submit_contact_info'
       m.contact_info          'contact-info',        :action => 'contact_info'

       m.submit_menu          'submit-menu', :action => 'submit_menu'
       m.menu                 'menu',        :action => 'menu'

       m.submit_payment_type  'submit-payment-type', :action => 'submit_payment_type'
       m.payment_type         'payment-type', :action => 'payment_type'

       m.submit_payment_by_credit_card 'submit-credit-card', :action => 'submit_payment_by_credit_card'
       m.payment_by_credit_card        'get-credit-card', :action => 'payment_by_credit_card'

       m.poll_for_credit_card_payment   'poll-for-payment',      :action => 'poll_for_credit_card_payment'

       m.payment_by_check   'get-check',      :action => 'payment_by_check'
       m.submit_payment_by_check   'submit-check',      :action => 'submit_payment_by_check'

       m.confirmation   'confirmation',      :action => 'confirmation'
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
RegistrationContact
RegistrationGroup
EventAttendee
Event
MenuChoice
require 'big_decimal'

case RAILS_ENV
when 'production'
  $prosperity_gateway = ActiveMerchant::Billing::ViaklixGateway.new :login => "405372", :user => "512psrc", :password => "TM2ZS9"
  $psrc_gateway       = ActiveMerchant::Billing::ViaklixGateway.new :login => "405372", :user => "439psrc", :password => "6C0YYD"
else
  $prosperity_gateway = ActiveMerchant::Billing::ViaklixGateway.new :login => "405372", :user => "512psrc", :password => "TM2ZS9", :test => true
  $psrc_gateway       = ActiveMerchant::Billing::ViaklixGateway.new :login => "405372", :user => "439psrc", :password => "6C0YYD", :test => true
end
