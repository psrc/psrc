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
      create_record :user, name.symbolize, user_params(attributes.update(:name => name))
    end
    def user_params(attributes)
      name = attributes[:name] || "John Doe"
      symbol = name.symbolize
      { 
        :name => name,
        :email => "#{symbol}@example.com", 
        :login => symbol,
        :password => User.sha1("password")
      }.merge(attributes)
    end
    
  end
end