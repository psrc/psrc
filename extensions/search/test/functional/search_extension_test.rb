require File.dirname(__FILE__) + '/../test_helper'

class SearchExtensionTest < Test::Unit::TestCase
  fixtures :pages
  
  def setup
    @controller = SiteController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end  
  
  def test_initialization
    assert_equal File.join(File.expand_path(RAILS_ROOT), 'vendor', 'extensions', 'search'), SearchExtension.root
    assert_equal 'Search', SearchExtension.extension_name
  end
  
end
