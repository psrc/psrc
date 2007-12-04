require File.dirname(__FILE__) + "/../../spec_helper"

describe Radiant::Configuration do
  before :each do
    @configuration = Radiant::Configuration.new
  end
  
  it "should be a Rails configuration" do
    @configuration.should be_kind_of(Rails::Configuration)
  end
  
  it "should have view_paths, extensions and extension_paths accessible" do
    %w{view_paths extensions extension_paths}.each do |m|
      @configuration.should respond_to(m)
      @configuration.should respond_to("#{m}=")
    end
  end
  
  it "should initialize the view paths to an array" do
    @configuration.view_paths.should_not be_nil
    @configuration.view_paths.should be_kind_of(Array)
  end
  
  it "should initialize the extension paths" do
    @configuration.extension_paths.should_not be_nil
    @configuration.extension_paths.should be_kind_of(Array)
    @configuration.extension_paths.should include("#{RADIANT_ROOT}/vendor/extensions") 
  end
  
  it "should have access to the AdminUI" do
    @configuration.admin.should == Radiant::AdminUI.instance
  end
end

describe Radiant::Initializer do

  before :each do
    @initializer = Radiant::Initializer.new(Radiant::Configuration.new)
  end
  
  it "should be a Rails initializer" do
    @initializer.should be_kind_of(Rails::Initializer)
  end
  
  it "should load extensions after initialization" do
    @initializer.should_receive(:initialize_extensions)
    @initializer.after_initialize
  end
  
  it "should invoke the extension loader when loading extensions" do
    Radiant::ExtensionLoader.instance.should_receive(:initializer=).with(@initializer)
    Radiant::ExtensionLoader.instance.should_receive(:run)
    @initializer.initialize_extensions
  end
  
  it "should print a warning if the extension meta table hasn't been created" do
    ActiveRecord::Base.connection.should_receive(:execute).with("select count(*) from #{Radiant::ExtensionMeta.table_name}").and_raise("Boom!")
    $stderr.should_receive(:puts).with("Extensions cannot be used until Radiant migrations are up to date.")
    @initializer.initialize_extensions
  end
  
  it "should initialize view paths" do
    [ActionView::Base, ActionMailer::Base].each do |klass|
      klass.should_receive(:view_paths=)
    end
    @initializer.initialize_view_paths
  end
  
  it "should initialize admin tabs" do
    @initializer.initialize_default_admin_tabs
    Radiant::AdminUI.instance.tabs.size.should == 3
  end
  
  it "should have access to the AdminUI" do
    @initializer.admin.should == Radiant::AdminUI.instance
  end
end
