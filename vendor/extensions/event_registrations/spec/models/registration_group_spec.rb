require File.dirname(__FILE__) + '/../spec_helper'

describe RegistrationGroup, "for a individual option" do
  before(:each) do
    option = EventOption.new :max_number_of_attendees => 1
    @group = RegistrationGroup.new :event_option => option
    @group.event_attendees << EventAttendee.new
  end

  it "should allow one person to register" do
    @group.valid?
    @group.errors.on(:event_attendees).should be_nil
  end

  it "shouldn't allow more than one person register" do
    @group.event_attendees << EventAttendee.new
    @group.valid?
    @group.errors.on(:event_attendees).should_not be_nil
  end


end
