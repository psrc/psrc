class Payment < ActiveRecord::Base

  def self.create_from_check check
    create! :amount => check.amount, :payment_method => "Check", :estimated_payment_date => check.payment_date
  end

  def self.create_from_card payment_card
    create! :amount => payment_card.amount, :payment_method => "Credit Card", :last_digits => payment_card.card.last_digits
  end
  
  private

  def valid_credit_card
    
  end


end
