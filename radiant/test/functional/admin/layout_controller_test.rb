require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/layout_controller'

# Re-raise errors caught by the controller.
class Admin::LayoutController; def rescue_action(e) raise e end; end

class Admin::LayoutControllerTest < Test::Unit::TestCase
  
  fixtures :users, :layouts
  
  def setup
    @controller = Admin::LayoutController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @developer_actions = [:index, :new, :edit, :remove]
  end

  def test_ancestors
    assert Admin::LayoutController.ancestors.include?(Admin::AbstractModelController)
  end
  
  def test_developer_action_allowed_if_admin
    @developer_actions.each do |action|
      get action, { :id => 1 }, { :user => users(:admin) }
      assert_response :success, "action: #{action}"
    end
  end
  def test_developer_action__allowed_if_developer
    @developer_actions.each do |action|
      get action, { :id => 1 }, { :user => users(:developer) }
      assert_response :success, "action: #{action}"
    end
  end
  def test_developer_action__not_allowed_if_other
    @developer_actions.each do |action|
      setup
      get action, { :id => 1 }, { :user => users(:existing) }, {}
      assert_redirected_to page_index_url, "action: #{action}"
      assert_match /privileges/, flash[:error], "action: #{action}"
    end
  end
end
