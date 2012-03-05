require File.dirname(__FILE__) + "/../test_helper"
require File.dirname(__FILE__) + "/../../spec/spec_helper"

class RegistrationTest < ActionController::IntegrationTest
  include TestHelpers

  def setup
    @event  = create_event
    @single_option = @event.event_options.find :first, :conditions => "max_number_of_attendees = 1"
    @group_option  = @event.event_options.find :first, :conditions => "max_number_of_attendees > 1"
  end
  
  # Elavon payment by credit card
  # Comment out if using payment_by_credit_card instead of payment_by_elavon
  def test_payment_with_elavon_table_signup
    pending "it should redirect to virtual merchant payment form"
  end
  
  def test_payment_with_elavon_single_signup
    pending "it should redirect to virtual merchant payment form"
  end

  def test_payment_with_elavon_prosperity_pin
    @event.update_attribute(:layout, 'prosperity')
    click_on_event @group_option
    fill_in_table_attendee_info 
    fill_in_contact_info
    select_credit_card
    assert response_body.include? %(<input id="ssl_pin" name="ssl_pin" type="hidden" value="TH3MS7" />)
  end

  def test_payment_with_elavon_psrc_pin
    click_on_event @group_option
    fill_in_table_attendee_info 
    fill_in_contact_info
    select_credit_card
    assert response_body.include? %(<input id="ssl_pin" name="ssl_pin" type="hidden" value="90MM5J" />)
  end

  # ActiveMerchant payment by credit card
  # Uncomment if using payment_by_credit_card instead of payment_by_elavon
  # def test_payment_with_credit_card_table_signup
  #   click_on_event @group_option
  #   fill_in_table_attendee_info 
  #   fill_in_contact_info
  #   select_credit_card
  #   fill_in_credit_card_form
  #   assert_registration_saved do
  #     payment_was_successful
  #   end
  # end
  # 
  # def test_payment_with_credit_card_single_signup
  #   click_on_event @single_option
  #   fill_in_attendee_info
  #   fill_in_contact_info
  #   select_credit_card
  #   fill_in_credit_card_form
  #   assert_registration_saved do
  #     payment_was_successful
  #   end
  # end

  def test_payment_with_check_single_signup
    click_on_event @single_option
    fill_in_attendee_info
    fill_in_contact_info
    select_check
    assert_registration_saved do
      fill_in_check_form
    end
  end

  def test_payment_with_check_table_signup
    click_on_event @group_option
    fill_in_table_attendee_info
    fill_in_contact_info
    select_check
    assert_registration_saved do
      fill_in_check_form
    end
  end

  # State not explicitly set when filling out the contact info page, should be WA by default.
  def test_washington_is_selected_by_default
    click_on_event(@single_option); fill_in_attendee_info

    assert response.body.include?("<option value=\"WA\" selected=\"selected\">Washington</option>") # Wonder if there's a way to do this via the webrat or rails api

    # Fill out the form, don't select the state option (so use whatever is selected)
    contact_info_without_state = DEFAULT_CONTACT_INFO.reject { |k, v| k =~ /state/i }
    fill_in_contact_info  contact_info_without_state
    session[:registration].registration_contact.state.should == "WA"
  end

end
