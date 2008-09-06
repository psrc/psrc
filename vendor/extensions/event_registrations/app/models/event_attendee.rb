class EventAttendee < ActiveRecord::Base
  belongs_to :registration_group

  def to_s
    result = "#{name} <#{email}>"
    result += " of #{ organization }" if organization
    result += " (V)" if vegetarian
    result
  end
end
