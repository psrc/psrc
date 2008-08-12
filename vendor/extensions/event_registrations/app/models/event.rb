class Event < ActiveRecord::Base
  has_many :event_options
end
