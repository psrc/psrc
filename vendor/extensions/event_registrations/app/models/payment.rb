class Payment
  @@gateway = ActiveMerchant::Billing::ViaklixGateway.new :login => "LOGIN", :password => "PASSWORD"

  def initialize card_values, amount
    @card = ActiveMerchant::Billing::CreditCard.new card_values
    @amount = amount
    start
  end

  def completed?
    @count ||= 0
    @count += 1
    if @count > 4
      return true
    else
      return false
    end
  end

  def error?
  end

  private

  def start
    # submit job to bj
  end
end
