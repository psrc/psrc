require File.dirname(__FILE__) + '/../test_helper'

class AdminUITest < Test::Unit::TestCase
  
  fixtures :users
  
  def setup
    add_tabs "First", "Second", "Third"
    @admin_user = users(:admin)
    @developer_user = users(:developer)
    @normal_user = users(:existing)
  end
  
  def test_mixins
    assert Radiant::AdminUI.included_modules.include?(Simpleton)
    assert Radiant::AdminUI::TabSet.included_modules.include?(Enumerable)
  end
  
  def test_tabs
    assert_kind_of Radiant::AdminUI::TabSet, admin.tabs
  end
  
  def test_brackets
    assert_equal "Second", admin.tabs["Second"].name
    assert_equal "Third", admin.tabs["Third"].name
  end
    
  def test_adding_tabs
    admin.tabs.add "Test", "/test"
    assert_equal "Test", admin.tabs[3].name
    
    admin.tabs.add "After", "/after", :after => "Second"
    assert_equal "After", admin.tabs[2].name
    
    admin.tabs.add "Before", "/before", :before => "Second"
    assert_equal "Before", admin.tabs[1].name
    
    assert_equal 6, admin.tabs.size
  end
  
  def test_removing_tabs
    admin.tabs.remove "Second"
    assert_equal 2, admin.tabs.size
    assert_equal "Third", admin.tabs[1].name
  end
  
  def test_cannot_add_tab_with_the_same_name
    assert_raises(Radiant::AdminUI::DuplicateTabNameError) { admin.tabs.add "First", "/first" }
  end
  
  def test_tab_visibility
    admin.tabs.add "Admin and Dev Tab", "/tab", :visibility => [:admin, :developer]
    tab = admin.tabs["Admin and Dev Tab"]
    
    assert_equal [:admin, :developer], tab.visibility
    assert_equal false, tab.shown_for?(@normal_user)
    assert_equal true, tab.shown_for?(@developer_user)
    assert_equal true, tab.shown_for?(@admin_user)
  end
  
  def test_tab_visibility__for
    admin.tabs.add "Developer Tab", "/developer", :for => :developer
    tab = admin.tabs["Developer Tab"]
    
    assert_equal [:developer], tab.visibility
    assert_equal false, tab.shown_for?(@normal_user)
    assert_equal true, tab.shown_for?(@developer_user)
    assert_equal false, tab.shown_for?(@admin_user)
  end
  
  def test_tab_visibility__everyone
    admin.tabs.add "Everyone Tab", "/developer"
    tab = admin.tabs["Everyone Tab"]
    
    assert_equal [:all], tab.visibility
    assert_equal true, tab.shown_for?(@normal_user)
    assert_equal true, tab.shown_for?(@developer_user)
    assert_equal true, tab.shown_for?(@admin_user)
  end
  
  private
  
    def admin
      @admin ||= Radiant::AdminUI.new
    end
  
    def add_tabs(*args)
      args.each do |name|
        admin.tabs.add name, "/#{name.underscore}"
      end
    end
  
end