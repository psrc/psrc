require File.dirname(__FILE__) + '/../test_helper'
require 'authors_controller'

# Re-raise errors caught by the controller.
class AuthorsController; def rescue_action(e) raise e end; end

class AuthorsControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :authors

  def setup
    @controller = AuthorsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_allow_signup
    assert_difference Author, :count do
      create_author
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference Author, :count do
      create_author(:login => nil)
      assert assigns(:author).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference Author, :count do
      create_author(:password => nil)
      assert assigns(:author).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference Author, :count do
      create_author(:password_confirmation => nil)
      assert assigns(:author).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference Author, :count do
      create_author(:email => nil)
      assert assigns(:author).errors.on(:email)
      assert_response :success
    end
  end
  

  protected
    def create_author(options = {})
      post :create, :author => { :login => 'quire', :email => 'quire@example.com', 
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
end
