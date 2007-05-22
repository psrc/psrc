require File.dirname(__FILE__) + '/../test_helper'

class ExtensionTest < Test::Unit::TestCase
  creator :name => "TestExtension", :code_url => "http://radiantcms.org/", :author_id => 1
  default_creation_test
  erroneous_creation_test :author_id, nil
  erroneous_creation_test :code_url, nil
  erroneous_creation_test :name, nil
end
