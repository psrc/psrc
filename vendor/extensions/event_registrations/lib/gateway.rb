module PaymentGateway
  def self.for_event event
    if event.psrc? or event.id == 6
      $psrc_gateway
    else
      $prosperity_gateway
    end
  end
end
