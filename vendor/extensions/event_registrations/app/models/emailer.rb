class Emailer < ActionMailer::Base
  PSRC_SYSTEM = "PSRC Registration <economicdevelopment@psrc.org>"
  PSRC_CONTACT = "PSRC Registration <joe@pinkpucker.net>"
  # PSRC_CONTACT = "Sylvia Nelson <snelson@psrc.org>"
  def registration_confirmation registration
    @from = PSRC_SYSTEM
    @recipients = [registration.registration_contact.email, PSRC_CONTACT]
    @subject = "#{ registration.event.name } Registration Confirmation!"
    body :registration => registration
  end
end
