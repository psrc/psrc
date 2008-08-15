class EventOption < ActiveRecord::Base
  belongs_to :event

  has_finder :table_options,      :conditions => "max_number_of_attendees > 1"
  has_finder :individual_options, :conditions => "max_number_of_attendees = 1"

  def self.max_table_seating
    self.table_options.find(:first).max_number_of_attendees
  end
end
