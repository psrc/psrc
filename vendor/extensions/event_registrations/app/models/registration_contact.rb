class RegistrationContact
  include Validatable

  attr_accessor :name, :title, :organization, :address, :city, :state, :zip, :email, :phone
  validates_presence_of :name, :address, :state, :city, :zip, :email, :phone

  def initialize hsh={}
    hsh.each do |key, value|
      instance_variable_set "@#{key}", value
    end
  end

  def to_s
    "#{name} (#{email})"
  end
end
