
Attendee

class AttendeeSet 
  attr_accessor :attendees
  attr_accessor :table_name
  attr_accessor :number_of_people
  include Validatable

  # Make sure that not all the attendees are blank, and that at least one of them is valid.
  validates_presence_of :table_name, :if => lambda { |a| a.number_of_people > 1 }

  def each
    @attendees.each {|a| yield a }
  end

  def initialize number_of_people
    @attendees = []
    @number_of_people = number_of_people
    @number_of_people.times { @attendees << Attendee.new }
  end

  def update attendees_info, table_name = ""
    @table_name = table_name
    attendees_info.each do |number, info| 
      @attendees[number.to_i] = Attendee.new(info)
    end
  end
  
end
