class MenuChoice < ActiveRecord::Base
  validates_presence_of :event_option
  validates_presence_of :description
  validates_presence_of :title

  belongs_to :event_option

  def to_s; title; end
end
