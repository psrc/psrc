
class BigDecimal
  # this works around http://code.whytheluckystiff.net/syck/ticket/24 until it gets fixed..
  alias :_original_to_yaml :to_yaml
  def to_yaml (opts={},&block)
    to_s.to_yaml(opts,&block)
  end
end

Registration

class Payment
  @@gateway = ActiveMerchant::Billing::ViaklixGateway.new :login => "LOGIN", :password => "PASSWORD"

  attr_reader :card, :registration_object


  def payment_method
    "Credit Card"
  end

  def initialize card_values, amount, registration_object
    @registration_object = registration_object
    @card = ActiveMerchant::Billing::CreditCard.new card_values
    raise @card.errors.full_messages.join(" and ") unless @card.valid?
    @amount = amount
    queue
  end

  def registration
    return nil unless completed?
    Registration.find(@job.stdout)
  end

  def completed?
    @job.finished? #and @job.exit_status == 0
  end

  def error?
    #@job.finished? and @job.exit_status != 0
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
    #attempt = @@gateway.purchase((@amount*100).to_i, @card)
    #if attempt.success?
      @registration_object.payment = self
      @registration_object.save!
      puts @registration_object.id
      exit 0
    #else
      #STDERR.puts attempt.message
      #exit -1
    #end
  end

  private

  def queue
    stdin = Base64.encode64(Marshal.dump(self))
    @job = Bj.submit("./script/runner Payment.start_purchase", :stdin => stdin).first
  end
end
