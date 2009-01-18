class MenuChoice < ActiveRecord::Base
  validates_presence_of :event_option
  validates_presence_of :description

  belongs_to :event_option
end
