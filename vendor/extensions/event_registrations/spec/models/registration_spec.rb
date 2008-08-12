require File.dirname(__FILE__) + '/../spec_helper'

describe Registration do
  before(:each) do
    @registration = Registration.new
  end

  it "should be valid" do
    @registration.should be_valid
  end
end
