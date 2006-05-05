require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/layout_controller'

# Re-raise errors caught by the controller.
class Admin::LayoutController; def rescue_action(e) raise e end; end

class Admin::LayoutControllerTest < Test::Unit::TestCase
  fixtures :users, :layouts
  test_helper :users, :layouts, :caching
  
  def setup
    @controller = Admin::LayoutController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @request.session[:user] = users(:developer)
    @cache = @controller.page_cache = FakePageCache.new
    @layout_name = 'Test Layout'
    @layout = layouts(:main)
  end

  def test_initialize
    @controller = Admin::LayoutController.new
    assert_kind_of PageCache, @controller.page_cache
  end

  def test_ancestors
    assert Admin::LayoutController.ancestors.include?(Admin::AbstractModelController)
  end
  
  [:index, :new, :edit, :remove].each do |action|
    define_method "test_#{action}_action_allowed_if_admin" do
      get action, { :id => 1 }, { :user => users(:admin) }
      assert_response :success, "action: #{action}"
    end
    
    define_method "test_#{action}_action__allowed_if_developer" do
      get action, { :id => 1 }
      assert_response :success, "action: #{action}"
    end
    
    define_method "test_#{action}_action__not_allowed_if_other" do
      get action, { :id => 1 }, { :user => users(:existing) }, {}
      assert_redirected_to page_index_url, "action: #{action}"
      assert_match /privileges/, flash[:error], "action: #{action}"
    end
  end
  
  def test_pages_that_use_layout_expired_on_save
    post :edit, :id => @layout.id, :layout => layout_params(:content => 'edited')
    assert_redirected_to layout_index_url
    assert_equal 2, @cache.expired_paths.size
    assert_equal 0, (@cache.expired_paths - ['/page-with-layout/', '/another-page-with-layout/']).size
  end
  
  def test_pages_that_use_layout_not_expired_on_save_when_invalid
    post :edit, :id => @layout.id, :layout => layout_params(:name => 'x' * 1000)
    assert_response :success
    assert_equal 0, @cache.expired_paths.size
  end
  
end
