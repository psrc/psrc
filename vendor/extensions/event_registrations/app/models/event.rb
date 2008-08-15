class Event < ActiveRecord::Base
  has_many :event_options
  delegate :table_options,      :to => :event_options
  delegate :individual_options, :to => :event_options
  delegate :max_table_seating,  :to => :event_options
end
