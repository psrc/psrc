require File.dirname(__FILE__) + "/../../spec_helper"

describe Radiant::ExtensionLoader do

  before :each do
    @observer = mock("observer")
    @configuration = mock("configuration")
    @initializer = mock("initializer")
    @initializer.stub!(:configuration).and_return(@configuration)
    @instance = Radiant::ExtensionLoader.send(:new)
    @instance.initializer = @initializer
    
    @extensions = %w{01_basic 02_overriding load_order_blue load_order_green load_order_red}
    @extension_paths = @extensions.map do |ext|
      File.expand_path("#{RADIANT_ROOT}/test/fixtures/extensions/#{ext}")
    end
    Radiant::AdminUI.tabs.clear
  end

  it "should be a Simpleton" do
    Radiant::ExtensionLoader.included_modules.should include(Simpleton)
  end

  it "should initialize extension roots on creation" do
    @instance.extension_roots.should_not be_nil
    @instance.extension_roots.should be_instance_of(Array)
  end

  it "should have the initializer's configuration" do
    @initializer.should_receive(:configuration).and_return(@configuration)
    @instance.configuration.should == @configuration
  end  
  
  it "should attach a dependencies observer, discover, and activate extensions when run" do
    Radiant::ExtensionLoader::DependenciesObserver.should_receive(:new).with(@configuration).and_return(@observer)
    @observer.should_receive(:observe).with(Dependencies)
    
    @instance.should_receive(:discover_extensions)
    @instance.should_receive(:activate_extensions)
    
    @instance.run
  end
  
  it "should find all extension roots" do
    @instance.instance_variable_set("@all_extension_roots", nil)
    @configuration.should_receive(:extension_paths).and_return(["#{RADIANT_ROOT}/test/fixtures/extensions"])
    all_extension_roots = @instance.send(:all_extension_roots)
    all_extension_roots.should == @extension_paths
  end
  
  it "should load all extensions by default" do
    @configuration.should_receive(:extensions).and_return(nil)
    @instance.stub!(:all_extension_roots).and_return(@extension_paths)
    @instance.send(:load_extension_roots).should == @instance.send(:all_extension_roots)
  end

  it "should only load extensions specified in the configuration" do
    @configuration.should_receive(:extensions).at_least(:once).and_return([:basic])
    @instance.stub!(:all_extension_roots).and_return(@extension_paths)
    @instance.send(:select_extension_roots).should == [File.expand_path("#{RADIANT_ROOT}/test/fixtures/extensions/01_basic")]  
  end
  
  it "should select extensions in an explicit order from the configuration" do
    extensions = [:load_order_red, :load_order_blue, :load_order_green]
    extension_roots = extensions.map {|ext| File.expand_path("#{RADIANT_ROOT}/test/fixtures/extensions/#{ext}") }
    @instance.stub!(:all_extension_roots).and_return(@extension_paths)
    @configuration.should_receive(:extensions).at_least(:once).and_return(extensions)
    @instance.send(:select_extension_roots).should == extension_roots
  end
  
  it "should insert all unspecified extensions into the paths at position of :all in configuration" do
    extensions = [:load_order_red, :all, :load_order_green]
    extension_roots = @extension_paths[0..-2].unshift(@extension_paths[-1])
    @instance.stub!(:all_extension_roots).and_return(@extension_paths)
    @configuration.should_receive(:extensions).at_least(:once).and_return(extensions)
    @instance.send(:select_extension_roots).should == extension_roots
  end
  
  it "should raise an error when an extension named in the configuration cannot be found" do
    extensions = [:foobar]
    @instance.stub!(:all_extension_roots).and_return(@extension_paths)
    @configuration.should_receive(:extensions).at_least(:once).and_return(extensions)
    lambda { @instance.send(:select_extension_roots) }.should raise_error(LoadError)
  end
  
  it "should determine load paths from an extension path" do
    @instance.send(:load_paths_for, "/blah").should == %w{
        /blah/lib
        /blah/app/models
        /blah/app/controllers
        /blah/app/helpers
        /blah/test/helpers
        /blah}
  end
  
  # Too coupled and long, but works for now
  it "should setup loading, view, and controller paths when discovering extensions" do
    lpaths, cpaths, vpaths = mock('lpaths'), mock('cpaths'), mock('vpaths')
    blah_paths = %w{/blah/lib /blah/app/models /blah/app/controllers /blah/app/helpers /blah/test/helpers /blah}
    @instance.stub!(:load_extension_roots).and_return(['/blah'])
    @configuration.should_receive(:load_paths).and_return(lpaths)
    lpaths.should_receive(:concat).with(blah_paths)
    $LOAD_PATH.should_receive(:concat).with(blah_paths)
    @configuration.should_receive(:controller_paths).and_return(cpaths)
    cpaths.should_receive(:<<).with("/blah/app/controllers")
    @configuration.should_receive(:view_paths).and_return(vpaths)
    vpaths.should_receive(:<<).with("/blah/app/views")
    @initializer.should_receive(:set_autoload_paths)
    @initializer.should_receive(:initialize_view_paths)
    @instance.discover_extensions.should == ['/blah']
    @instance.extension_roots.should == ['/blah']
  end
  
  it "should activate discovered extensions" do
    @configuration.stub!(:extensions).and_return(@extensions)
    @configuration.stub!(:extension_paths).and_return(["#{RADIANT_ROOT}/test/fixtures/extensions"])
    @instance.extension_roots = @extension_paths
    @initializer.should_receive(:initialize_default_admin_tabs).and_return(true)
    @initializer.should_receive(:initialize_routing)
    @instance.activate_extensions

    [BasicExtension, OverridingExtension, LoadOrderGreenExtension, 
      LoadOrderRedExtension, LoadOrderBlueExtension].each do |ext|
        ext.should be_active
    end
  end
  
  it "should enable specific extensions when activating" do
    @configuration.stub!(:extensions).and_return(@extensions)
    @configuration.stub!(:extension_paths).and_return(["#{RADIANT_ROOT}/test/fixtures/extensions"])
    @instance.extension_roots = @extension_paths
    @initializer.should_receive(:initialize_default_admin_tabs).and_return(true)
    @initializer.should_receive(:initialize_routing)
    @instance.activate_extensions(%w{Basic Overriding})
    
    [BasicExtension, OverridingExtension].each do |ext|
      ext.should be_active
    end
    [LoadOrderGreenExtension, LoadOrderRedExtension, LoadOrderBlueExtension].each do |ext|
      ext.should_not be_active
    end
  end
  
  it "should activate an extension only if it is enabled" do
    OverridingExtension.enable(false)
    OverridingExtension.should_not_receive(:activate)
    @instance.send(:activate, OverridingExtension)
    OverridingExtension.should_not be_active
  end
  
  it "should deactivate loaded extensions" do
    BasicExtension.should be_active
    BasicExtension.should_receive(:deactivate)
    @instance.deactivate_extensions
  end
  
  it "should deactivate an extension only if it is active" do
    LoadOrderGreenExtension.deactivate
    LoadOrderGreenExtension.should_not_receive(:deactivate)
    @instance.send(:deactivate, LoadOrderGreenExtension)
    LoadOrderGreenExtension.should_not be_active
  end
  
  it "should enable an extension" do
    OverridingExtension.enable(false)
    @instance.send(:enable, OverridingExtension, true)
    OverridingExtension.should be_enabled
  end
end


describe Radiant::ExtensionLoader::DependenciesObserver do
  before :each do
    @config = mock("rails config")
    @observer = Radiant::ExtensionLoader::DependenciesObserver.new(@config)
  end

  it "should be a MethodObserver" do
    @observer.should be_kind_of(MethodObserver)
  end
  
  it "should attach to the clear method" do
    @observer.should respond_to(:before_clear)
    @observer.should respond_to(:after_clear)
  end
  
  it "should deactivate extensions before clear" do
    Radiant::ExtensionLoader.should_receive(:deactivate_extensions)
    @observer.before_clear
  end
  
  it "should activate extensions after clear" do
    Radiant::ExtensionLoader.should_receive(:activate_extensions)
    @observer.after_clear
  end
end
