require File.dirname(__FILE__) + '/../spec_helper'

describe RegistrationsController do
  integrate_views

  before(:each) do
    @event = create_event
    @option = @event.event_options.first
  end

  it "shouldn't error out when going straight to the confirmation page" do
    get :attendee_info, :event_option_id => @option.id, :event_id => @event.id
    get :confirmation
    response.should be_redirect
  end

  it "should show the attendee info page" do
    get :attendee_info, :event_option_id => @option.id, :event_id => @event.id
    assigns(:number_of_attendees).should == @option.max_number_of_attendees
  end

  it "should remember the attendee info" do
    session[:registration] = Registration.new
    session[:current_registration_step] = 1
    post :submit_attendee_info, :event_option_id => @option.id, :event_id => @event.id, :person => {0 => { :name => "Joe", :email => "joe@pinkpucker.net" } }, :group => { :group_name => "Joe's Table" }
    session[:registration].registration_groups.first.event_option.should == @option
    assert_redirected_to :action => "contact_info"
  end
end
