require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/user_controller'

# Re-raise errors caught by the controller.
class Admin::UserController; def rescue_action(e) raise e end; end

class Admin::UserControllerTest < Test::Unit::TestCase
  
  fixtures :users
  test_helper :user, :logging, :login

  def setup
    @controller = Admin::UserController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @user = create_test_user
    login_as(@user)
  end
  
  def teardown
    destroy_test_user
  end

  def test_ancestors
    assert Admin::UserController.ancestors.include?(Admin::AbstractModelController)
  end
  
  [:index, :new, :edit, :remove].each do |action|
    define_method "test_#{action}_action_allowed_if_admin" do
      login_as(:admin)
      get action, { :id => 1 }
      assert_response :success, "action: #{action}"
    end

    define_method "test_#{action}_action_not_allowed_if_other" do
      login_as(:non_admin)
      get action, { :id => 1 }
      assert_redirected_to page_index_url, "action: #{action}"
      assert_match /privileges/, flash[:error], "action: #{action}"
    end
  end
  
  def test_remove__cannot_remove_self
    @user = users(:admin)
    login_as(@user)
    get :remove, { :id => @user.id }
    assert_redirected_to user_index_url
    assert_match /cannot.*self/i, flash[:error]
    assert_not_nil User.find(@user.id)
  end
  
  def test_preferences
    get :preferences, :user => { :email => 'updated@email.com' }
    assert_response :success
    assigned_user = assigns(:user)
    assert_equal @user, assigned_user
    assert @user.object_id != assigned_user.object_id
    assert_equal 'jdoe@gmail.com', assigned_user.email
  end
  def test_preferences__post
    post(
      :preferences,
      { :user => { :password => '', :password_confirmation => '', :email => 'updated@gmail.com' } }
    )
    @user = User.find(@user.id)
    assert_redirected_to page_index_url
    assert_match /preferences.*?saved/i, flash[:notice] 
    assert_equal 'updated@gmail.com', @user.email
  end
  def test_preferences__post_with_bad_data
    get :preferences, 'user' => { :login => 'superman' }
    assert_response :success
    assert_match /bad form data/i, flash[:error]
  end
  
  def test_change_password
    @user = User.create!(:name => 'Test', :login => 'pref_test', :password => 'whoa!', :password_confirmation => 'whoa!')
    login_as(@user)
    post(
      :preferences,
      { :user => { :password => 'funtimes', :password_confirmation => 'funtimes' } }
    )
    @user = User.find(@user.id)
    assert_equal User.sha1('funtimes'), @user.password
    
    assert !log_matches(/"password"=>"funtimes"/)
    assert !log_matches(/"password_confirmation"=>"funtimes"/)
  end

end
