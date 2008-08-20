class Event < ActiveRecord::Base
  has_many :event_options
  delegate :max_table_seating, :to => :event_options

  def table_options
     self.event_options.select { |o| o.max_number_of_attendees > 1 }
  end
  
  def individual_options
     self.event_options.select { |o| o.max_number_of_attendees == 1 }    
  end

end
