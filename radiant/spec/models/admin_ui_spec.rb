require File.dirname(__FILE__) + '/../spec_helper'

describe Radiant::AdminUI do
  
  it 'should include Simpleton behavior' do
    Radiant::AdminUI.included_modules.should include(Simpleton)
  end
  
  it 'should answer tabs' do
    Radiant::AdminUI.new.tabs.should be_instance_of(Radiant::AdminUI::TabSet)
  end
  
end

describe Radiant::AdminUI::TabSet do
  include Admin
  
  scenario :users
  
  before :all do
    @admin_user = users(:admin)
    @developer_user = users(:developer)
    @normal_user = users(:existing)
  end
  
  before :each do
    ["First", "Second", "Third"].each do |name|
      tabs.add name, "/#{name.underscore}"
    end
  end
  
  it 'should include Enumerable behavior' do
    Radiant::AdminUI::TabSet.included_modules.should include(Enumerable)
  end
  
  it 'should allow brackets' do
    tabs["Second"].name.should == "Second"
    tabs["Third"].name.should == "Third"
  end
  
  it 'should allow adding tabs' do
    tabs.add "Test", "/test"
    tabs[3].name.should == "Test"
    
    tabs.add "After", "/after", :after => "Second"
    tabs[2].name.should == "After"
    
    tabs.add "Before", "/before", :before => "Second"
    tabs[1].name.should == "Before"
    
    tabs.size.should == 6
  end
  
  it 'should allow removing tabs' do
    tabs.remove "Second"
    tabs.size.should == 2
    tabs[1].name.should == "Third"
  end
  
  it 'should not allow you to add a tab with the same name' do
    lambda { tabs.add "First", "/first" }.should raise_error(Radiant::AdminUI::DuplicateTabNameError)
  end
  
  it 'should correctly answer tab visibility with multiple options' do
    tabs.add "Admin and Dev Tab", "/tab", :visibility => [:admin, :developer]
    tab = tabs["Admin and Dev Tab"]
    tab.visibility.should == [:admin, :developer]
    tab.should_not be_shown_for(@normal_user)
    tab.should be_shown_for(@developer_user)
    tab.should be_shown_for(@admin_user)
  end
  
  it 'should correctly answer tab visibility with :for parameter' do
    tabs.add "Developer Tab", "/developer", :for => :developer
    tab = tabs["Developer Tab"]
    tab.visibility.should == [:developer]
    tab.should_not be_shown_for(@normal_user)
    tab.should be_shown_for(@developer_user)
    tab.should_not be_shown_for(@admin_user)
  end
  
  it 'should correctly answer tab visibility normally' do
    tabs.add "Everyone Tab", "/developer"
    tab = tabs["Everyone Tab"]
    tab.visibility.should == [:all]
    tab.should be_shown_for(@normal_user)
    tab.should be_shown_for(@developer_user)
    tab.should be_shown_for(@admin_user)
  end
  
  private
    
    def tabs
      @tabs ||= Radiant::AdminUI::TabSet.new
    end
    
end