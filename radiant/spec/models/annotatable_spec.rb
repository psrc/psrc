require File.dirname(__FILE__) + '/../spec_helper'
require 'annotatable'

describe "Annotatable" do
  
  class A
    @@inherited_called = false
    def self.inherited(subclass)
      @@inherited_called = true
    end
    def self.inherited_called
      @@inherited_called
    end
    
    include Annotatable
    annotate :description, :url
    annotate :another, :inherit => true
    
    description "just a test"
    another     "inherit me"
  end
  
  class B < A
    url "http://test.host"
  end
  
  class C < B
    description "something else"
    another     "still inherit me"
  end
  
  class D < C; end
  
  specify 'annotations on superclass' do
    A.description.should == "just a test"
    A.url.should be_nil
    A.another.should == "inherit me"
    
    A.new.description.should == "just a test"
    A.new.url.should == nil
    A.new.another.should == "inherit me"
  end
  
  specify 'annotations on subclass' do
    B.description.should be_nil
    B.url.should == "http://test.host"
    B.another.should == "inherit me"
    
    B.new.description.should be_nil
    B.new.url.should == "http://test.host"
    B.new.another.should == "inherit me"
  end
  
  specify 'annotations on a subclass of a subclass' do
    C.description.should == "something else"
    C.url.should be_nil
    C.another.should == "still inherit me"
    
    C.new.description.should == "something else"
    C.new.url.should be_nil
    C.new.another.should == "still inherit me"
  end
  
  specify 'annotations on a subclass of a subclass of a subclass' do
    D.description.should == nil
    D.url.should == nil
    D.another.should == "still inherit me"
    
    D.new.description.should == nil
    D.new.url.should == nil
    D.new.another.should == "still inherit me"
  end
  
  specify 'when a class is inherited super should be called inside the inherited method' do
    A.inherited_called.should be_true
  end
  
end