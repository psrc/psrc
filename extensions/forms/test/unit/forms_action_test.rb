require File.dirname(__FILE__) + '/../test_helper'

class FormsActionTest < Test::Unit::TestCase

  class TrackingAction < Forms::Action
    description "Tracks activity."
  end

  class CustomAction < Forms::Action
    action_name "Really Custom"
    description_file File.dirname(__FILE__) + "/../fixtures/sample.txt"
  end

  def test_description
    assert_equal %{Tracks activity.}, TrackingAction.description    
  end
  
  def test_description_file
    assert_equal File.read(File.dirname(__FILE__) + "/../fixtures/sample.txt"), CustomAction.description
  end
  
  def test_action_name
    assert_equal 'Forms Action Test Tracking', TrackingAction.action_name
  end
  
  def test_custom_action_name
    assert_equal 'Really Custom', CustomAction.action_name
  end

end