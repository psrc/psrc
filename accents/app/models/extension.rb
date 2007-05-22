class Extension < ActiveRecord::Base
  validates_presence_of :name, :author_id, :code_url
  belongs_to :author  
end
