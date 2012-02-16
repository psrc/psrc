class Event < ActiveRecord::Base
  has_many :event_options, :order => "description"
  has_many :registration_groups
  delegate :max_table_seating, :to => :event_options
  has_many :registrations
  delegate :event_attendees, :to => :registrations

  validates_presence_of :name
  validates_presence_of :start_date
  validates_presence_of :end_date
  validates_presence_of :contact_email
  
  belongs_to :banner, :class_name => "Asset"

  def early_available?
    self.event_options.any? { |option| option.early_available? }
  end
  
  def table_options
     self.event_options.find :all, :conditions => "max_number_of_attendees > 1"
  end
  
  def individual_options
     self.event_options.find :all, :conditions => "max_number_of_attendees = 1"
  end

  def number_of_attendees
    sum = 0
    event_options.each do |option|
      sum += option.number_of_attendees
    end
    sum
  end

  def psrc?
    self.layout =~ /psrc/i
  end

  def default_contact_email
    if psrc?
      "srogers@psrc.org"
    else
      "orobinson@psrc.org"
    end
  end

end
