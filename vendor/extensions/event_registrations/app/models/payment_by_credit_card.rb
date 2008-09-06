class ActiveMerchant::Billing::CreditCard
  attr_accessor :address, :zip
  def validate_with_check_address
    errors.add(:address, "must be provided") if address.blank?
    errors.add(:zip, "must be provided") if zip.blank?
    validate_without_check_address
  end
  alias_method_chain :validate, :check_address

  def billing_address
    { :address1 => address, :zip => zip }
  end

end

class PaymentByCreditCard
  @@gateway = ActiveMerchant::Billing::ViaklixGateway.new :login => "405372", :user => "512psrc", :password => "TM2ZS9", :test => true

  attr_reader :card, :registration_object, :amount

  def payment_method
    "Credit Card"
  end

  def valid?
    @card.valid?
  end

  def initialize card_values, amount, registration_object
    @registration_object = registration_object
    @card = ActiveMerchant::Billing::CreditCard.new card_values
    raise "Please double-check your credit card information below." unless @card.valid?
    @amount = amount
    queue
  end

  def registration
    return nil unless completed?
    Registration.find(@job.stdout)
  end

  def completed?
    @job = @job.reload
    @job.finished? and @job.exit_status == 0
  end

  def error?
    @job.finished? and @job.exit_status != 0
  end

  def error_message
    @job.stderr.chomp
  end

  # Load purchase object from STDIN, decode/unmarshal it, and execute purchase
  def self.start_purchase
    purchase = Marshal.load(Base64.decode64(STDIN.read))
    purchase.execute_purchase
  end

  # Authorize purchase from gateway
  def execute_purchase
    attempt = @@gateway.purchase((@amount*100).to_i, @card, :billing_address => @card.billing_address )
    if attempt.success?
      @registration_object.payment = Payment.create_from_card(self)
      @registration_object.save!
      puts @registration_object.id
      exit 0
    else
      STDERR.puts attempt.message
      exit -1
    end
  end

  private

  def queue
    stdin = Base64.encode64(Marshal.dump(self))
    @job = Bj.submit("./script/runner PaymentByCreditCard.start_purchase", :stdin => stdin).first
  end
end
