require File.dirname(__FILE__) + '/../spec_helper'

describe Payment, "from credit card" do
  before(:each) do
    card = PaymentByCreditCard.new(test_credit_card_values, 1.99, String)
    @payment = Payment.create_from_card(card)
  end

  it "should be valid" do
    @payment.should be_valid
    @payment.should_not be_new_record
  end

  it "should remember the payment amount" do
    @payment.amount.should == BigDecimal.new("1.99")
  end

  it "should know that it's a credit card" do
    @payment.payment_method.should == "Credit Card"
  end
end


describe Payment, "from a check" do
  before(:each) do
    check = PaymentByCheck.new(:payment_date => (Date.today + 1), :amount => 5.99)
    @payment = Payment.create_from_check check
  end

  it "should be valid" do
    @payment.should be_valid
    @payment.should_not be_new_record
  end

  it "should remember the payment amount" do
    @payment.amount.should == BigDecimal.new("5.99")
  end

  it "should know that it's a Check" do
    @payment.payment_method.should == "Check"
  end

  it "should know that the estimated delivery date is a month from now" do
    @payment.estimated_payment_date.should == (Date.today + 1)
  end
end
