require File.dirname(__FILE__) + '/../spec_helper'

describe Registration, "for two people" do
  before(:each) do
    ActionMailer::Base.deliveries = []
    @event                = create_event
    @registration_contact = create_registration_contact
    @reg                  = Registration.new :registration_contact => @registration_contact, :event => @event
    @option               = @event.event_options.build :description => "Event Description", :max_number_of_attendees => 1, :normal_price => 10
    @group1               = @reg.registration_groups.build :event_option => @option
    @group2               = @reg.registration_groups.build :event_option => @option

    @joe    = @group1.event_attendees.build :name => "Joe Smith", :email => "joe@tanga.com"
    @jordan = @group2.event_attendees.build :name => "Jordan Isip", :email => "jordan@isip.com"

    @group1.registration = @reg
    @group2.registration = @reg
    payment = @reg.build_payment
    @reg.save!
  end

  it "should have a payment amount equal to the cost of two event options" do
    @reg.payment_amount.should == (@option.price * 2)
  end

  it "should remember who's registered for the event" do
    @reg.event_attendees.should be_include(@joe)
    @reg.event_attendees.should be_include(@jordan)
  end

  it "should send one email" do
    ActionMailer::Base.deliveries.size.should == 1
    email = ActionMailer::Base.deliveries.shift
    email.to.should == [@registration_contact.email]
    email.subject.should be_include(@event.name)
    email.bcc .should == [Emailer::PSRC_CONTACT]
    email.from.should == [Emailer::PSRC_SYSTEM.match(/<(.+)>/)[1]]
  end
end

describe Registration, "for one person and two tables" do
  before(:each) do
    @event                = create_event
    @registration_contact = create_registration_contact
    @reg                  = Registration.new :registration_contact => @registration_contact, :event => @event
    @ind_option           = @event.event_options.create :description => "I Event Description", :max_number_of_attendees => 1,  :normal_price => 10
    @ind_group            = @reg.registration_groups.build :event_option => @ind_option
    @table_option         = @event.event_options.create :description => "T Event Description", :max_number_of_attendees => 10, :normal_price => 100
    @table_group1         = @reg.registration_groups.build :event_option => @table_option, :group_name => "Joe's Table"
    @table_group2         = @reg.registration_groups.build :event_option => @table_option, :group_name => "Jordan's Table"

    @table_group1.registration = @reg
    @table_group2.registration = @reg
    @ind_group.  registration = @reg

    payment = @reg.build_payment

    @reg.save!
  end

  it "should have a payment amount equal to the cost of one individual event options and two tables event options" do
    @reg.payment_amount.should == (2 * @table_option.price + @ind_option.price)
  end

end
