require File.dirname(__FILE__) + '/../test_helper'

class LoginSystemTest < Test::Unit::TestCase
  
  fixtures :users
  test_helper :routing, :login
  
  class StubController < ActionController::Base
    def rescue_action(e)
      raise e
    end
    
    def method_missing(method, *args, &block)
      if (args.size == 0) and not block_given?
        render :text => 'just a test'
      else
        super
      end
    end
  end
  
  class LoginRequiredController < StubController
    include LoginSystem
    
    attr_writer :condition
    
    def condition?
      @condition ||= false
    end
  end
  
  class NoLoginRequiredController < LoginRequiredController
    no_login_required
  end
  
  class OnlyAllowAccessToWhenController < LoginRequiredController
    only_allow_access_to :edit, :new, :when => [:admin, :developer], :denied_url => { :action => :test }, :denied_message => 'Fun.'
  end
  
  class OnlyAllowAccessToWhenDefaultsController < LoginRequiredController
    only_allow_access_to :edit, :when => :admin
  end
  
  class OnlyAllowAccessToIfController < LoginRequiredController
    only_allow_access_to :edit, :if => :condition?
  end
  
  def setup
    @controller = LoginRequiredController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    setup_custom_routes
  end
  
  def teardown
    teardown_custom_routes
  end
  
  def test_authenticate__with_user_in_session
    login_as(:existing)
    get :index
    assert_response :success
  end
  def test_authenticate__without_user_in_session
    get :index
    assert_redirected_to login_url
  end
  
  # Class Methods
  
  def test_no_login_required
    @controller = NoLoginRequiredController.new
    get :index
    assert_response :success
  end
  
  def test_only_allow_access_to__when_user_in_role
    @controller = OnlyAllowAccessToWhenController.new
    login_as(:admin)
    get :edit
    assert_response :success
  end
  def test_only_allow_access_to__when_user_in_role_2
    @controller = OnlyAllowAccessToWhenController.new
    login_as(:developer)
    get :new
    assert_response :success
  end
  def test_only_allow_access_to__when_user_in_role_3
    @controller = OnlyAllowAccessToWhenController.new
    login_as(:admin)
    get :another
    assert_response :success
  end
  def test_only_allow_access_to__when_user_not_in_role
    @controller = OnlyAllowAccessToWhenController.new
    login_as(:non_admin)
    get :edit
    assert_redirected_to :action => :test
    assert_equal 'Fun.', flash[:error]
  end
  def test_only_allow_access_to__when_user_not_in_role_2
    @controller = OnlyAllowAccessToWhenController.new
    login_as(:non_admin)
    get :new
    assert_redirected_to :action => :test
    assert_equal 'Fun.', flash[:error]
  end
  def test_only_allow_access_to__when__user_not_in_role_3
    @controller = OnlyAllowAccessToWhenController.new
    login_as(:non_admin)
    get :another
    assert_response :success
  end
  def test_only_allow_access_to__when__user_not_in_role__defaults
    @controller = OnlyAllowAccessToWhenDefaultsController.new
    login_as(:non_admin)
    get :edit
    assert_redirected_to :action => :index
    assert_equal 'Access denied.', flash[:error]
  end
  
  def test_only_allow_access_to__if__condition_true
    @controller = OnlyAllowAccessToIfController.new
    @controller.condition = true
    login_as(:existing)
    get :edit
    assert_response :success
  end
  def test_only_allow_access_to__if__condition_false
    @controller = OnlyAllowAccessToIfController.new
    @controller.condition = false
    login_as(:existing)
    get :edit
    assert_response :redirect
  end

end
