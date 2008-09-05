class Emailer < ActionMailer::Base
  PSRC_CONTACT = "PSRC Registration <joe@pinkpucker.net>"
  def registration_confirmation registration
    @from = PSRC_CONTACT
    @recipients = [registration.registration_contact.email, PSRC_CONTACT]
    @subject = "#{ registration.event.name } Registration Confirmation!"
    body :registration => registration
  end
end
