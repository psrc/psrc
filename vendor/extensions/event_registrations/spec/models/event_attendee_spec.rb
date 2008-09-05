require File.dirname(__FILE__) + '/../spec_helper'

describe EventAttendee do
  before(:each) do
    @event_attendee = EventAttendee.new
  end

  it "should be valid" do
    @event_attendee.should be_valid
  end
end
