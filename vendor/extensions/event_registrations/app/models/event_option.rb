class EventOption < ActiveRecord::Base
  belongs_to :event
  def self.max_table_seating
    find(:first, :order => 'max_number_of_attendees desc').max_number_of_attendees
  end
end
