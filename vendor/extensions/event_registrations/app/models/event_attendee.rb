class EventAttendee < ActiveRecord::Base
  belongs_to :registration_group

  def to_s
    name_email = "#{name} (<a href='mailto:#{email}'>#{email}</a>)"
    name_email += " of #{ organization }" if organization
    name_email += " (V)" if vegetarian
    name_email
  end
end
