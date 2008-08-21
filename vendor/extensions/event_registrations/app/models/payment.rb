Registration
class Payment
  @@gateway = ActiveMerchant::Billing::ViaklixGateway.new :login => "LOGIN", :password => "PASSWORD"

  attr_reader :card

  def initialize card_values, amount, registration_object
    @registration_object = registration_object
    @card = ActiveMerchant::Billing::CreditCard.new card_values
    raise @card.errors.full_messages.join(" and ") unless @card.valid?
    @amount = amount
    queue
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
      @registration_object.save!
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
