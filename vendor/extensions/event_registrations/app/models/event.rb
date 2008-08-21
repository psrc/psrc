class Event < ActiveRecord::Base
  has_many :event_options
  delegate :max_table_seating, :to => :event_options

  def table_options
     self.event_options.find :all, :conditions => "max_number_of_attendees > 1"
  end
  
  def individual_options
     self.event_options.find :all, :conditions => "max_number_of_attendees = 1"
  end

  def number_of_attendees
    sum = 0
    event_options.each do |option|
      sum += option.number_of_attendees
    end
    sum
  end

end
