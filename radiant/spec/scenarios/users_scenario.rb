class UsersScenario < Scenario::Base
  
  def load
    create_user "Existing"
    create_user "Another"
    create_user "Admin", :admin => true
    create_user "Developer", :developer => true
    create_user "Non-admin", :admin => false
  end
  
  helpers do
    def create_user(name, attributes={})
      create_record :user, name.symbolize, user_attributes(attributes.update(:name => name))
    end
    def user_attributes(attributes={})
      name = attributes[:name] || "John Doe"
      symbol = name.symbolize
      attributes = { 
        :name => name,
        :email => "#{symbol}@example.com", 
        :login => symbol.to_s,
        :password => "password"
      }.merge(attributes)
      attributes[:password] = User.sha1(attributes[:password])
      attributes
    end
    def user_params(attributes={})
      password = attributes[:password] || "password"
      user_attributes(attributes).update(:password => password, :password_confirmation => password)
    end
    def login_as(user)
      logged_in_user = user.is_a?(User) ? user : users(user)
      flunk "Can't login as non-existing user #{user.to_s}." unless logged_in_user
      request ||= ActionController::TestRequest.new
      request.session['user_id'] = logged_in_user.id
    end
  end
end