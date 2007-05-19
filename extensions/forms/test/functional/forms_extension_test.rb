require File.dirname(__FILE__) + '/../test_helper'

class FormsExtensionTest < Test::Unit::TestCase

  def test_initialization
    assert_equal File.join(File.expand_path(RAILS_ROOT), 'vendor', 'extensions', 'forms'), FormsExtension.root
    assert_equal 'Forms', FormsExtension.extension_name
  end
  
end
