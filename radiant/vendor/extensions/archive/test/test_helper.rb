require 'test/unit'
# # Load the environment
unless defined? RADIANT_ROOT
  ENV["RAILS_ENV"] = "test"
  env_file = "#{File.expand_path(File.dirname(__FILE__) + "/" + "../" * 6)}/config/environment.rb"
  unless File.exist?(env_file)
    env_file = "#{File.expand_path(File.dirname(__FILE__) + "/" + "../" * 4)}/config/environment.rb"
  end
  require env_file
end
require "#{RADIANT_ROOT}/test/test_helper"

class Test::Unit::TestCase
  
  # Include a helper to make testing Radius tags easier
  test_helper :extension_tags
  
  # Add the fixture directory to the fixture path
  self.fixture_path << File.expand_path(File.dirname(__FILE__)) + '/fixtures'
  
  # Add more helper methods to be used by all extension tests here...
  
end
