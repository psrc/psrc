class EventOption < ActiveRecord::Base
  belongs_to :event
  def self.max_table_seating
    find(:first, :order => 'max_number_of_attendees desc').max_number_of_attendees
  end

  def early_available?
    !early_price_date.blank? and !early_price.blank?
  end

  def price
    if !early_available? or Date.today > self.early_price_date
      self.normal_price
    else
      self.early_price
    end
  end
end
