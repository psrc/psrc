require File.dirname(__FILE__) + '/../test_helper'

class ExtensionInitializationTest < Test::Unit::TestCase
  def setup
    Dependencies.mechanism = :load
    Radiant::ExtensionLoader.reactivate Radiant::Extension.descendants
  end
  
  def teardown
    Dependencies.mechanism = :require
  end
  
  def test_load_paths
    assert_nothing_raised { BasicExtension }
    assert_equal File.join(File.expand_path(RADIANT_ROOT), 'test', 'fixtures', 'extensions', '01_basic'), BasicExtension.root
    assert_equal 'Basic', BasicExtension.extension_name
    assert_nothing_raised { BasicExtensionController }
    assert_nothing_raised { BasicExtensionModel }
  end
  
  def test_reloading
    assert_basic_extension_annotations
    assert_view_paths
    assert_admin_tabs "Basic Extension Tab"
    
    BasicExtensionController.instance_variable_set("@action_methods", nil) # ActionController cached no index action
    BasicExtension.version = "should get changed back on clear"
    BasicExtensionController.module_eval do
      def index
        render :text => "should get changed back on clear"
      end
    end
    assert_view_paths :index => /should get changed/
    
    #only want to clear the test extensions
    old_list = Dependencies.explicitly_unloadable_constants
    Dependencies.explicitly_unloadable_constants = Radiant::Extension.descendants.select {|ex| ex.root.index(TEST_ROOT) == 0}.map {|x| x.name }
    Dependencies.clear
    Dependencies.explicitly_unloadable_constants = old_list

    assert_basic_extension_annotations
    assert_view_paths
    assert_admin_tabs "Basic Extension Tab"

  end
  
  def test_reactivate
    assert_admin_tabs "Basic Extension Tab"
    Radiant::ExtensionLoader.reactivate []
    assert Radiant::AdminUI.tabs.all? {|tab| tab.name != "Basic Extension Tab" }
  ensure
    Radiant::ExtensionLoader.reactivate Radiant::Extension.descendants
    assert BasicExtension.active?
  end
  
  def test_view_paths
    assert_view_paths
  end
  
  def test_mailer_view_paths
    mail = BasicExtensionMailer.create_message
    assert_match /Hello, Extension Mailer World/, mail.body
  end
  
  def test_basic_extension_annotations
    assert_basic_extension_annotations
  end

  def test_should_load_plugin_from_vendor_plugin
    assert_nothing_raised { Radiant::Extension.const_get(:PLUGIN_PLUGIN_NORMAL) }
    assert_equal BasicExtension.root + "/vendor/plugins/plugin_normal", Radiant::Extension::PLUGIN_PLUGIN_NORMAL
    assert $LOAD_PATH.include?(BasicExtension.root + "/vendor/plugins/plugin_normal/lib")
    assert Dependencies.load_paths.include?(BasicExtension.root + "/vendor/plugins/plugin_normal/lib")
    assert Dependencies.load_once_paths.include?(BasicExtension.root + "/vendor/plugins/plugin_normal/lib")    
    assert defined?(NormalPlugin)
  end
    
  def test_should_load_multiple_location_plugin_from_first_extension_in_load_order
    assert_nothing_raised { Radiant::Extension.const_get(:PLUGIN_MULTIPLE) }
    assert_equal BasicExtension.root + "/vendor/plugins/multiple", Radiant::Extension::PLUGIN_MULTIPLE
    assert $LOAD_PATH.include?(BasicExtension.root + "/vendor/plugins/multiple/lib")
    assert Dependencies.load_paths.include?(BasicExtension.root + "/vendor/plugins/multiple/lib")
    assert Dependencies.load_once_paths.include?(BasicExtension.root + "/vendor/plugins/multiple/lib")    
    assert defined?(Multiple)
    assert_not_equal OverridingExtension.root + "/vendor/plugins/multiple", Radiant::Extension::PLUGIN_MULTIPLE
    assert !$LOAD_PATH.include?(OverridingExtension.root + "/vendor/plugins/multiple/lib")
    assert !Dependencies.load_paths.include?(OverridingExtension.root + "/vendor/plugins/multiple/lib")
    assert !Dependencies.load_once_paths.include?(OverridingExtension.root + "/vendor/plugins/multiple/lib")    
  end

  def test_should_add_extension_load_paths_to_requirable_load_path
    assert_nothing_raised { require 'new_module' }
    assert defined?(NewModule)
  end
  
  private
  
    def assert_admin_tabs(more_tabs = [])
      tabnames = []
      Radiant::AdminUI.tabs.each do |tab|
        assert "Duplicate Tab", !tabnames.include?(tab.name)
        tabnames << tab.name
      end
      more_tabs.each do |tabname|
        assert Radiant::AdminUI.tabs.any? {|tab| tab.name == tabname }
      end
    end
    
    def assert_basic_extension_annotations
      assert_equal "1.1", BasicExtension.version
      assert_equal "just a test", BasicExtension.description
      assert_equal "http://test.com", BasicExtension.url
    end
  
    def assert_view_paths(expected = {}, message = nil)
      expected.reverse_merge!({
        :index    => /Hello, Extension World/,
        :override => /Hello, Overridden Extension World/,
        :routing  => /You're routing works/,
      })
        
      @controller = BasicExtensionController.new
      @request    = ActionController::TestRequest.new
      @response   = ActionController::TestResponse.new
      
      [:index, :override, :routing].each do |action|
        get action
        assert_match expected[action], @response.body, message
      end
    end
end
