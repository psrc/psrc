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
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures = false
end
