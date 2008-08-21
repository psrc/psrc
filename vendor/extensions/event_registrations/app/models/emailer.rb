class Emailer < ActionMailer::Base
  PSRC_CONTACT = "awerfelmann@psrc.org"
  def registration_confirmation registration
    @recipients = [registration.registration_contact.email, PSRC_CONTACT]
    @subject = "Thanks for registering for the #{ registration.event.name } event!"
    body :registration => registration
  end
end
