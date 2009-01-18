require File.dirname(__FILE__) + '/../spec_helper'

describe MenuChoice do
  before(:each) do
    @menu_choice = MenuChoice.new
  end

  it "should be valid" do
    @menu_choice.should be_valid
  end
end
