require File.dirname(__FILE__) + '/../spec_helper'

describe EventOption do
  before(:each) do
    @event_option = EventOption.new
  end

  it "should be valid" do
    @event_option.should be_valid
  end
end
