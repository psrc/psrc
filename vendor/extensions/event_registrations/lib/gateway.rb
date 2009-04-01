module PaymentGateway
  def self.for_event event
    if event.psrc?
      $psrc_gateway
    else
      $prosperity_gateway
    end
  end
end
