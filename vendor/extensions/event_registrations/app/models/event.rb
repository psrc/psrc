class Event < ActiveRecord::Base
  has_many :event_options, :order => "description"
  delegate :max_table_seating, :to => :event_options
  validates_presence_of :name

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
