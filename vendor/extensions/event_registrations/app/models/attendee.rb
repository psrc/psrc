class Attendee 
  include Validatable

  attr_accessor :name, :email, :vegetarian

  validates_presence_of :name
  validates_presence_of :email

  validates_format_of :email, :with => ValidatesEmailFormatOf::Regex

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
