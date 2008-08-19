require File.dirname(__FILE__) + '/../spec_helper'

describe Payment do
  before(:each) do
    @payment = Payment.new
  end

  it "should be valid" do
    @payment.should be_valid
  end
end
