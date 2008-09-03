require File.dirname(__FILE__) + "/../test_helper"
require File.dirname(__FILE__) + "/../../spec/spec_helper"

class RegistrationTest < ActionController::IntegrationTest
  def setup
    @event = create_event
    @option = @event.event_options.first
  end

   def test_happy_path
     get event_path(@event)
     clicks_link @option.description
     fills_in "set_table_name", :with => "Our Table Name"
     fills_in "person[0][name]", :with => "Joe"
     fills_in "person[0][email]", :with => "joe@pinkpucker.net"
     clicks_button "Continue"
   end
end
