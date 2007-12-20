require File.dirname(__FILE__) + '/../spec_helper'

# http://blog.davidchelimsky.net/articles/2007/06/03/oxymoron-testing-behaviour-of-abstractions
describe ApplicationController do
  scenario :users
  
  before :all do
    # @user = users(:admin)    
    @controller = ApplicationController.new
  end
  
  it 'should include LoginSystem' do
    ApplicationController.include?(LoginSystem)
  end
  
  it 'should initialize config' do
    @controller.config.should == Radiant::Config
  end
  
  # it 'should capture current user'

end

# def test_before_filter
#   UserActionObserver.current_user = nil
#   login_as(@user)
#   get :test
#   assert_response :success
#   assert_equal @user, UserActionObserver.current_user
# end

# def login_as(user)
  # logged_in_user = user.is_a?(User) ? user : users(user)
  # flunk "Can't login as non-existing user #{user.to_s}." unless logged_in_user
  # @request ||= ActionController::TestRequest.new
  # @request.session['user_id'] = logged_in_user.id
# end
