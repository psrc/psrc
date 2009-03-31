module Payment
  def payment_gateway event
    if @event.psrc?
      $psrc_gateway
    else
      $prosperity_gateway
    end
  end
end
