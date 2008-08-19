
class AttendeeSet 
  attr_accessor :attendees

  def each
    @attendees.each {|a| yield a }
  end

  def valid?
    return false if @attendees.blank?
    !@attendees.find { |a| !a.blank? and !a.valid? }
  end

  def initialize number_of_people
    @attendees = []
    number_of_people.times { @attendees << Attendee.new }
  end

  def fill attendees_info
    attendees_info.each do |number, info| 
      a = Attendee.new info
      @attendees[number.to_i] = a 
    end
  end
  
  def errors
    result = []
    @attendees.each { |a| result << a.errors.full_messages unless a.blank? or a.valid?}
    result
  end
end
