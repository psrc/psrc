class RegistrationGroup < ActiveRecord::Base
  has_many :event_attendees
  belongs_to :registration
  belongs_to :event_option
  validates_presence_of :event_option
  validates_presence_of :registration
  validate :check_for_max_attendees

  private

  def check_for_max_attendees
    if self.event_option.max_number_of_attendees < self.event_attendees.size
      errors.add(:event_attendees, "More event attendees than allowed (#{ self.event_attendees.size} added, #{ self.event_option.max_number_of_attendees} allowed)")
      return false
    end
  end
end
