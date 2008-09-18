require File.dirname(__FILE__) + '/../spec_helper'

describe Payment, "from credit card" do
  def create_payment values=test_credit_card_values, amount=1.99, klass=String
    card = PaymentByCreditCard.new(test_credit_card_values, 1.99, klass)
    Payment.create_from_card(card)
  end

  before(:each) do
    @payment = create_payment
  end

  it "should be valid" do
    @payment.should be_valid
    @payment.should_not be_new_record
  end

  it "should remember the payment amount" do
    @payment.amount.should == BigDecimal.new("1.99")
  end
  
  it "should remember the last four digits of card" do
    @payment.last_digits.should == test_credit_card_values[:number][12..15]
  end

  it "should know that it's a credit card" do
    @payment.payment_method.should == "Credit Card"
  end

  it "should be ok with all data correctly entered" do
    PaymentByCreditCard.new(test_credit_card_values, '1.99', String) 
  end

  it "should force entry of zip code" do
    lambda { card = PaymentByCreditCard.new(test_credit_card_values.update(:zip => ''), '1.99', String) }.should raise_error(RuntimeError)
  end

  it "should force entry of address" do
    lambda { card = PaymentByCreditCard.new(test_credit_card_values.update(:address => ''), '1.99', String) }.should raise_error(RuntimeError)
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
