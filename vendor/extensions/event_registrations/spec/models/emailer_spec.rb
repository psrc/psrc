require File.dirname(__FILE__) + '/../spec_helper'

describe Emailer do
  before(:each) do
    @emailer = Emailer.new
  end

  it "should be valid" do
    @emailer.should be_valid
  end
end
