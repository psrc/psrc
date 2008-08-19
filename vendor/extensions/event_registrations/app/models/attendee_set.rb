
class AttendeeSet 
  attr_accessor :attendees
  include Validatable

  # Make sure that not all the attendees are blank, and that at least one of them is valid.
  validates_each :attendees, :logic => lambda { errors.add(:attendees, "is not valid") if !@attendees.find {|a| !a.blank? } or @attendees.find { |a| !a.blank? and !a.valid? } }

  def each
    @attendees.each {|a| yield a }
  end

  def initialize number_of_people
    @attendees = []
    number_of_people.times { @attendees << Attendee.new }
  end

  def update attendees_info
    attendees_info.each do |number, info| 
      @attendees[number.to_i] = Attendee.new(info)
    end
  end
  
end
