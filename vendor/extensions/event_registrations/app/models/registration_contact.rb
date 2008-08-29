class RegistrationContact
  include Validatable

  attr_accessor :name, :title, :organization, :address, :city, :state, :country, :zip, :email, :phone
  validates_presence_of :name, :address, :state, :city, :zip, :email, :phone

  validates_format_of :email, :with => ValidatesEmailFormatOf::Regex

  def initialize hsh={}
    hsh.each do |key, value|
      instance_variable_set "@#{key}", value
    end
  end
  
  def to_s
    "#{name} (<a href='mailto:#{email}'>#{email}</a>)"
  end
end
