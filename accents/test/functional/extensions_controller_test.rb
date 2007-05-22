require File.dirname(__FILE__) + '/../test_helper'
require 'extensions_controller'

# Re-raise errors caught by the controller.
class ExtensionsController; def rescue_action(e) raise e end; end

class ExtensionsControllerTest < Test::Unit::TestCase
  fixtures :extensions

  def setup
    @controller = ExtensionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:extensions)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_extension
    old_count = Extension.count
    post :create, :extension => { }
    assert_equal old_count+1, Extension.count
    
    assert_redirected_to extension_path(assigns(:extension))
  end

  def test_should_show_extension
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_extension
    put :update, :id => 1, :extension => { }
    assert_redirected_to extension_path(assigns(:extension))
  end
  
  def test_should_destroy_extension
    old_count = Extension.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Extension.count
    
    assert_redirected_to extensions_path
  end
end
