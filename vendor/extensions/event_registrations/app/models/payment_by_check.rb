
class PaymentByCheck
  include Validatable
  validates_acceptance_of :agreement
  validates_presence_of :payment_date, :amount
  attr_accessor :payment_date, :agreement, :amount

  def payment_method
    "Check (Approx delivery date: #{ payment_date })"
  end

  def initialize options={}
    options.each do |key, value|
      instance_variable_set "@#{key}", value
    end
  end
end
