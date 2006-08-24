# Include hook code here

# TODO: hope to move these patches to the trunk
puts "Load patches ..."
Dir["#{RADIANT_ROOT}/vendor/plugins/search_behavior/lib/patches/*.rb"].sort.each do |patch|
  puts patch
  require patch 
end

require 'acts_as_ferret'
require 'page_acts_as_ferret'
require 'admin_page_controller_rebuilds_index'
require 'search'
