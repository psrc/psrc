class Registration < ActiveRecord::Base
  belongs_to :event_option
  delegate :event, :to => :event_option

  serialize :registration_set,      AttendeeSet
  serialize :registration_contact,  RegistrationContact

  validates_presence_of :registration_set
  validates_presence_of :registration_contact
  validates_presence_of :event_option

  after_create :send_confirmation_email

  def number_of_attendees
    self.registration_set.attendees.find_all { |a| !a.blank? }.size
  end

  private

  def send_confirmation_email
    Emailer.deliver_registration_confirmation self
  end
end
