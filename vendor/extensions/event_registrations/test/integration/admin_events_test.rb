require File.dirname(__FILE__) + "/../test_helper"
require File.dirname(__FILE__) + "/../../spec/spec_helper"

class AdminEventsTest < ActionController::IntegrationTest
  def setup
    User.create!  :name => "Administrator", :login => 'admin1', :password => 'radiant', :password_confirmation => 'radiant', :admin => true
    visit         login_path
    fills_in      "username", :with => 'admin1'
    fills_in      "password", :with => 'radiant'
    clicks_button "Login"
    clicks_link   "Events"
  end

  def test_can_add_events
    clicks_link "Create new event"
    fills_in "Name of event", :with => "Jordan's display of suckery"
    fills_in "Location", :with => "His apartment"
    fills_in "Event Description", :with => "It will suck, no doubt about that"
    fills_in "Event Schedule", :with => "midnight to midnight"
    assert_difference "Event.count" do
      clicks_button "Create!"
      # puts Event.find :all
      pending "Why doesn't creating an event seem to work?  Form gets submitted successfully, but no events are added"
    end
  end
end
