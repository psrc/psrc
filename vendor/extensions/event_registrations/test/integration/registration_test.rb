require File.dirname(__FILE__) + "/../test_helper"
require File.dirname(__FILE__) + "/../../spec/spec_helper"

module TestHelpers
  DEFAULT_ATTENDEE_INFO = { :table_name => "Joe's Table",
                            :attendees => [ { :name => "Joe", :email => "joe@pinkpucker.net" } ] }

  DEFAULT_CONTACT_INFO  = { "name"              => "Joe",
                            "mailing address"   => "123 Main",
                            "city"              => "Seattle",
                            "State/Province"    => "Washington",
                            "zip/postal code"   => "98028",
                            "e-mail address"    => "joe@pinkpucker.net",
                            "phone number"      => "1234567890" }


  # Clicks on the given event option for an event
  def click_on_event option = @option
     visits       event_path(option.event)
     clicks_link  @option.description
  end

  # Fills in the Attendee Information page
  def fill_in_attendee_info options = DEFAULT_ATTENDEE_INFO
    fills_in "Table Name", :with => options[:table_name] if options[:table_name]

    options[:attendees].each_with_index do |attendee, i|
      fills_in "person[#{i}][name]",      :with => attendee[:name]
      fills_in "person[#{i}][email]",     :with => attendee[:email]
      checks   "person[#{i}][vegetarian]" if attendee[:vegetarian]
    end

    clicks_button "Continue"
  end

  # Fills in the Contact Information page
  def fill_in_contact_info options = DEFAULT_CONTACT_INFO
    options.each do |option, value|
      begin
        fills_in option, :with => value
      rescue RuntimeError # different method needed for picking from select box (i.e. the State box)
        selects value, :from => option
      end
    end
    clicks_button "Continue"
  end

  # Picks a credit card on the Payment Type page
  def select_credit_card
    chooses "Credit Card"
    clicks_button "Continue"
  end

  def select_check
    chooses "Check"
    clicks_button "Continue"
  end

  def fill_in_check_form
    check "payment[agreement]"
    clicks_button "Purchase"
  end

  def fill_in_credit_card_form
    fills_in "Credit Card Number", :with => 4111111111111111
    selects "Dec", :from =>  "Expiration Month"
    selects "2012", :from =>  "Expiration Year"
    fills_in "First Name", :with => "Joe"
    fills_in "Last Name", :with => "Van Dyk"
    fills_in "Billing Address", :with => "19646 62nd Ave NE"
    fills_in "Billing Address Zip Code", :with => "98028"
    fills_in "Card Verification Number", :with => "123"
    clicks_button "Purchase"
  end

  def payment_was_successful
    # There's gotta be a better way to manually run a bj job
    job = session[:payment].instance_variable_get("@job")
    command = job.command
    env = job.env || {}
    stdin = job.stdin || ''
    stdout = job.stdout || ''
    stderr = job.stderr || ''
    started_at = Time.now
    thread = Bj::Util.start job.command, :cwd=>Bj.rails_root, :env=> env, :stdin=>stdin, :stdout=>stdout, :stderr=>stderr
    exit_status = thread.value
    finished_at = Time.now
    job = Bj::Table::Job.find job.id
    job.state = "finished"
    job.finished_at = finished_at
    job.stdout = stdout
    job.stderr = stderr
    job.exit_status = exit_status
    job.save!

    get poll_for_credit_card_payment_path
    follow_redirect!
  end

  def assert_registration_saved
    yield
    assert !session[:registration].new_record?
  end
end

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
