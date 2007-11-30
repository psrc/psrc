require File.dirname(__FILE__) + '/../spec_helper'

describe InheritableClassAttributes do
  class A
    include InheritableClassAttributes
    
    cattr_inheritable_reader :reader
    @reader = :test
    
    cattr_inheritable_writer :writer
    @writer = :test
    
    cattr_inheritable_accessor :accessor
    @accessor = :test
  end
  
  specify 'inheritable reader' do
    A.reader.should == :test
  end
  
  specify 'inheritable writer' do
    A.writer = :changed
    A.module_eval(%{@writer}).should == :changed
  end
  
  specify 'inheritable accessor' do
    A.accessor = :changed
    A.accessor.should == :changed
  end
  
  specify 'inheritance' do
    A.accessor = :unchanged
    Kernel.module_eval %{ class B < A; end }
    B.accessor = :changed
    B.accessor.should == :changed
    A.accessor.should == :unchanged
  end
  
  specify 'array inheritance' do
    A.accessor = [1,2,3]
    Kernel.module_eval %{ class C < A; end }
    C.accessor << 4
    C.accessor.should == [1,2,3,4]
    A.accessor.should == [1,2,3]
  end
end