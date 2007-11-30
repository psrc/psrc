require File.dirname(__FILE__) + '/../spec_helper'

describe MethodObserver do
  
  class TestObject
    cattr_accessor :captures
    @@captures = [:invoked, :before_called, :after_called, :before_result, :after_result]
    
    attr_accessor *captures
    
    def test(result)
      @invoked = true
      result
    end
  end
  
  class TestObserver < MethodObserver    
    def before_test(args, &block)
      target.before_called = true
      target.before_result = result
    end
    
    def after_test(args)
      target.after_called = true
      target.after_result = result
    end
  end
  
  before(:all) do
    @object = TestObject.new
    @observer = TestObserver.new
    @observer.observe(@object)
  end
  
  it 'should be able to observe a method' do
    TestObject.captures.each do |c|
      @object.send(c).should be_nil
    end
    
    @object.test(:result)
    
    TestObject.captures.reject { |c| c == :before_result }.each do |c|
      @object.send(c).should_not be_nil
    end
    @object.before_result.should be_nil
  end
  
  it 'should not allow you to observe a method twice' do
    e = assert_raises(MethodObserver::ObserverCannotObserveTwiceError) { @observer.observe(@object) }
    e.message.should == 'observer cannot observe twice'
  end
  
end