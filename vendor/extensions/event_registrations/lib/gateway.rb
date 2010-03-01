module PaymentGateway
  def self.for_event event
    if event.id == 6
      $edd_gateway
    else
      $psrc_gateway
    end
  end
end
