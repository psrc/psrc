require File.dirname(__FILE__) + "/../test_helper"
require File.dirname(__FILE__) + "/../../spec/spec_helper"

class RegistrationTest < ActionController::IntegrationTest
  include TestHelpers

  def setup
    @event  = create_event
    @option = @event.event_options.first
  end

   def test_payment_with_credit_card
     click_on_event
     fill_in_attendee_info
     fill_in_contact_info
     select_credit_card
     fill_in_credit_card_form
     assert_registration_saved do
       payment_was_successful
     end
   end

   def test_payment_with_check
     click_on_event
     fill_in_attendee_info
     fill_in_contact_info
     select_check
     assert_registration_saved do
       fill_in_check_form
     end
   end

   # State not explicitly set when filling out the contact info page, should be WA by default.
   def test_washington_is_selected_by_default
     click_on_event; fill_in_attendee_info

     assert response.body.include?("<option value=\"WA\" selected=\"selected\">Washington</option>") # Wonder if there's a way to do this via the webrat or rails api

     # Fill out the form, don't select the state option (so use whatever is selected)
     contact_info_without_state = DEFAULT_CONTACT_INFO.reject { |k, v| k =~ /state/i }
     fill_in_contact_info  contact_info_without_state
     session[:registration].registration_contact.state.should == "WA"
   end

end
