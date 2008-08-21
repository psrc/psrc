class Emailer < ActionMailer::Base
  PSRC_CONTACT = "joe@tanga.com"
  def registration_confirmation registration
    @recipients = [registration.registration_contact.email, PSRC_CONTACT]
    @subject = "Thanks for registering for the #{ registration.event.name } event!"
    body :registration => registration
  end
end
