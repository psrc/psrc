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
require "#{RADIANT_ROOT}/spec/spec_helper"

if File.directory?(File.dirname(__FILE__) + "/scenarios")
  Scenario.load_paths.unshift File.dirname(__FILE__) + "/scenarios"
end
if File.directory?(File.dirname(__FILE__) + "/matchers")
  Dir[File.dirname(__FILE__) + "/matchers/*.rb"].each {|file| require file }
end

Spec::Runner.configure do |config|
  # config.use_transactional_fixtures = true
  # config.use_instantiated_fixtures  = false
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures'

  # You can declare fixtures for each behaviour like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so here, like so ...
  #
  #   config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
end

def create_event
  event = Event.new :name => "Joe's Event", :layout => 'psrc'
  event.event_options.build :description => "Descrition of option 1", :max_number_of_attendees => 2, :normal_price => 10
  event.event_options.build :description => "Descrition of option 2", :max_number_of_attendees => 1, :normal_price => 20
  event.start_date = Date.today
  event.end_date = Date.today + 1
  event.save! and event
end

def create_registration_contact
  RegistrationContact.create! :email => "joe@pinkpucker.net", :name => "Joe Van Dyk", :address => '123 main', :city => "Seattle", :state => "WA", :zip => "98028", :phone => "123"
end

def test_credit_card_values
  { :month => 9, :year => Time.now.year + 1, :first_name => "Joe", :last_name => "Van Dyk", :number => "4111111111111111", :verification_value => '123', :address => "123 Main", :zip => "98028" }
end
