require File.dirname(__FILE__) + '/../test_helper'

# Re-raise errors caught by the controller.
FuzzyBearsController.class_eval { def rescue_action(e) raise e end }

class FuzzyBearsControllerTest < Test::Unit::TestCase
  def setup
    @controller = FuzzyBearsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
