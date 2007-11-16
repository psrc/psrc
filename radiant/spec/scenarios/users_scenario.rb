class UsersScenario < Scenario::Base
  def load
    create_user "Existing"
    create_user "Another"
    create_user "Admin", :admin => true
    create_user "Developer", :developer => true
    create_user "Non-admin", :admin => false
  end
  
  helpers do
    def create_user(name, attrs={})
      short_name = name.underscore.downcase
      create_record(:user, short_name.to_sym, 
                {:name => name, 
                 :email => "#{short_name}@example.com", 
                 :login => short_name,
                 :password => User.sha1("password")}.merge(attrs))
    end
  end
end
