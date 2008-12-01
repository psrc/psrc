class EventOption < ActiveRecord::Base
  belongs_to :event
  has_many :registration_groups
  has_many :registrations, :through => :registration_groups
  validates_presence_of :description
  validates_presence_of :max_number_of_attendees
  validates_presence_of :normal_price

  def payment_required?
    self.price > 0
  end

  def self.max_table_seating
    find(:first, :order => 'max_number_of_attendees desc').max_number_of_attendees
  end

  def number_of_attendees
    self.registrations.find(:all).sum { |r| r.number_of_attendees }
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

  def seating_type
    if is_table?
      "Table - up to #{self.max_number_of_attendees}"
    elsif is_individual?
      "Individual"
    end
  end

  def is_individual?
    self.max_number_of_attendees == 1
  end

  def is_table?
    self.max_number_of_attendees > 1
  end
end
