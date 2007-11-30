require File.dirname(__FILE__) + '/../spec_helper'

describe Radiant::Extension do
  
  it 'admin' do
    Radiant::Extension.admin.should equal(Radiant::AdminUI.instance)
  end
  
  class BasicExtensionObserver < MethodObserver
    cattr_accessor :activate_called, :deactivate_called
    @@activate_called = false
    def before_activate
      @@activate_called = true
    end
    @@deactivate_called = false
    def before_deactivate
      @@deactivate_called = true
    end
  end
  
  it 'should activate correctly' do
    BasicExtension.activate
    BasicExtension.active?.should be_true
    BasicExtensionObserver.new.observe(BasicExtension.instance)
    BasicExtension.activate
    BasicExtension.active?.should be_true
    BasicExtensionObserver.activate_called.should_not be_true
  end
  
  it 'should activate correclty' do
    BasicExtension.active?.should be_true
    BasicExtensionObserver.new.observe(BasicExtension.instance)
    BasicExtension.deactivate
    BasicExtension.active?.should_not be_true
    BasicExtensionObserver.deactivate_called.should be_true
    BasicExtensionObserver.deactivate_called = false
    BasicExtension.deactivate
    BasicExtension.active?.should_not be_true
    BasicExtensionObserver.deactivate_called.should_not be_true
  end
  
end