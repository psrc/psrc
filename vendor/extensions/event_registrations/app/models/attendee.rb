class Attendee 
  include Validatable

  attr_accessor :name, :email, :organization, :vegetarian

  def initialize hsh={}
    hsh.each do |key, value|
      instance_variable_set "@#{key}", value
    end
  end

  def to_s
    name_email = "#{name} (<a href='mailto:#{email}'>#{email}</a>)"
    name_email += " (V)" if vegetarian == "1"
    name_email
  end

  def blank?
    name.blank? and email.blank?
  end

end
