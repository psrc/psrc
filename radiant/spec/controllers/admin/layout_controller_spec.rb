require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::LayoutController do
  scenario :users, :layouts

  before :each do
    login_as :developer
  end

  it "should be an AbstractModelController" do
    controller.should be_kind_of(Admin::AbstractModelController)
  end

  it "should handle Layouts" do
    controller.class.model_class.should == Layout
  end

  [:index, :new, :edit, :remove].each do |action|
    it "should require login to access the #{action} action" do
      logout
      lambda { get action }.should require_login
    end

    it "should allow access to developers" do
      lambda { get action, :id => layout_id(:main) }.should restrict_access(:allow => [users(:developer)])
    end
    
    it "should allow access to admins" do
      lambda { get action, :id => layout_id(:main) }.should restrict_access(:allow => [users(:admin)])
    end
    
    it "should deny non-developers and non-admins" do
      lambda { get action }.should restrict_access(:deny => [users(:non_admin), users(:existing)])
    end
  end
end