require File.dirname(__FILE__) + '/../spec_helper'

describe PublisherHelper do

  #Delete this example and add some real ones or delete this file
  it "should include the PublisherHelper" do
    included_modules = self.metaclass.send :included_modules
    included_modules.should include(PublisherHelper)
  end

end
