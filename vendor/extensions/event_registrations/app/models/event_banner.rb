class EventBanner < ActiveRecord::Base
  has_attachment :storage => :file_system, 
                 :path_prefix => 'public/system/event_banners',
                 :max_size => 10.megabytes, :processor => :rmagick
  belongs_to :event
end
