class EventAttendee < ActiveRecord::Base
  belongs_to :registration_group
  belongs_to :menu_choice

  def to_s
    result = "#{name} <#{email}>"
    result += " of #{ organization }" if !organization.blank?
    result += " menu choice: #{ menu_choice }" if menu_choice
    result
  end
end
