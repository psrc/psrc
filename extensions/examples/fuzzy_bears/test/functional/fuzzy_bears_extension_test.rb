require File.dirname(__FILE__) + '/../test_helper'

class FuzzyBearsExtensionTest < Test::Unit::TestCase
  
  # Replace this with your real tests.
  def test_this_extension
    flunk
  end
  
  def test_initialization
    assert_equal File.join(File.expand_path(RAILS_ROOT), 'vendor', 'extensions', 'fuzzy_bears'), FuzzyBearsExtension.root
    assert_equal 'Fuzzy Bears', FuzzyBearsExtension.extension_name
  end
  
end
