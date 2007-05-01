require 'routing_extension'
require 'view_paths_extension'
require 'mailer_view_paths_extension'
if RAILS_ENV != 'production'
  require 'generator_base_extension' 
end
require 'fixture_loading_extension'