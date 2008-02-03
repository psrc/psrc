require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::UserController do
  scenario :users
  
  [:index, :new, :edit, :remove, :preferences].each do |action|
    it "should require login to access #{action}" do
      lambda { get action }.should require_login
    end
  end
  
  [:index, :new, :edit, :remove].each do |action|
    it "should allow access to #{action} action to admin users" do
      lambda { get action, :id => user_id(:existing) }.should restrict_access(:allow => users(:admin))
    end
    
    it "should deny access to #{action} action non-admin users" do
      lambda { get action, :id => user_id(:existing) }.should restrict_access(:deny => [users(:developer), users(:existing)])
    end
  end
end