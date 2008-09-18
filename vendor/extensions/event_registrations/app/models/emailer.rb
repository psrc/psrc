class Emailer < ActionMailer::Base
  PSRC_SYSTEM = "PSRC Registration <economicdevelopment@psrc.org>"
  PSRC_CONTACT = "Sylvia Nelson <snelson@psrc.org>, Andrew Werfelmann <AWerfelmann@psrc.org"

  def registration_confirmation registration
    @from         = PSRC_SYSTEM
    @recipients   = registration.registration_contact.email 
    @bcc          = PSRC_CONTACT
    @subject      = "#{ registration.event.name } Registration Confirmation!"
    body :registration => registration
  end
end
