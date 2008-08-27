
class PaymentByCheck
  include Validatable
  validates_acceptance_of :agreement
  validates_presence_of :payment_date
  attr_accessor :payment_date, :agreement

  def payment_method
    "Check <br /><small>Approx delivery date: #{ payment_date }</small>"
  end

  def initialize options={}
    options.each do |key, value|
      instance_variable_set "@#{key}", value
    end
  end
end
