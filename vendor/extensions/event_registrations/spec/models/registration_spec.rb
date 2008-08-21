require File.dirname(__FILE__) + '/../spec_helper'

describe Registration do
  before(:each) do
    event = Event.create! :description => "foo"
    option = EventOption.create! :event => event, :description => "goo"
    @registration_set = AttendeeSet.new 5
    @registration_set.update({ 1 => { :name => "jordan", :email => "jordan@isip.com" }, 0 => {:name => "Joe", :email => "joe@vandyk.com"}}, "table name here")
    @registration_contact = RegistrationContact.new :name => "Contact"
    registration = Registration.create! :registration_set => @registration_set, :registration_contact => @registration_contact, :event_option => option
    registration.should be_valid
  end

  it "should create a registration object" do
    reg = Registration.find :first # reload from scratch
    reg.registration_set.attendees[0].name.should == "Joe"
    reg.registration_set.attendees[1].name.should == "jordan"
    reg.registration_set.attendees[2].name.should == nil
    reg.registration_contact.name.should == "Contact"
  end
end
