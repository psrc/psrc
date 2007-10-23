module LoginTestHelper
  def self.included(base)
    base.class_eval{ fixtures :users }
  end
  
  def login_as(user)
    logged_in_user = user.is_a?(User) ? user : users(user)
    flunk "Can't login as non-existing user #{user.to_s}." unless logged_in_user
    @request ||= ActionController::TestRequest.new
    @request.session['user_id'] = logged_in_user.id
  end
  
  def logout
    @request ||= ActionController::TestRequest.new
    @request.session['user_id'] = nil
  end
end
