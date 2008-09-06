require 'test/unit'
# Load the environment
unless defined? RADIANT_ROOT
  ENV["RAILS_ENV"] = "test"
  case
  when ENV["RADIANT_ENV_FILE"]
    require ENV["RADIANT_ENV_FILE"]
  when File.dirname(__FILE__) =~ %r{vendor/radiant/vendor/extensions}
    require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../../../")}/config/environment"
  else
    require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../")}/config/environment"
  end
end
require "#{RADIANT_ROOT}/test/test_helper"

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures = false
end

module TestHelpers
  DEFAULT_ATTENDEE_INFO = { :table_name => "Joe's Table",
                            :attendees => [ { :name => "Joe", :email => "joe@pinkpucker.net" } ] }

  DEFAULT_CONTACT_INFO  = { "full name"              => "Joe",
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
    fills_in "Zip Code", :with => "98028"
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
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    assert session[:registration].new_record?, "Registration should be not saved yet"
    yield
    assert !session[:registration].new_record?, "Registration should have been saved"
    pending "Look into why testing for emails in integration tests doesn't work."
    assert !ActionMailer::Base.deliveries.empty?, "Emails should have been sent."
  end
end
