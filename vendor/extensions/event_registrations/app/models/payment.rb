class Payment < ActiveRecord::Base
  def self.create_from_check check
    create! :amount => check.amount, :payment_method => "Check", :estimated_payment_date => check.payment_date
  end

  def self.create_from_card card
    create! :amount => card.amount, :payment_method => "Credit Card"
  end
end
