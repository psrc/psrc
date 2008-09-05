class Emailer < ActionMailer::Base
  PSRC_CONTACT = "joe@pinkpucker.net"
  def registration_confirmation registration
    @recipients = [registration.registration_contact.email, PSRC_CONTACT]
    @subject = "#{ registration.event.name } Registration Confirmation!"
    body :registration => registration
  end
end
