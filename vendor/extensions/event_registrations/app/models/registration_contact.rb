class RegistrationContact < ActiveRecord::Base
  has_one :registration
  validates_presence_of :name, :address, :state, :city, :zip, :email, :phone
  validates_format_of :email, :with => ValidatesEmailFormatOf::Regex

  def formatted_address
    [address, state, city, zip].join(", ")
  end

  def to_s
    "#{name} (<a href='mailto:#{email}'>#{email}</a>)"
  end
end
