require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/export_controller'

# Re-raise errors caught by the controller.
class Admin::ExportController; def rescue_action(e) raise e end; end

class Admin::ExportControllerTest < Test::Unit::TestCase
  fixtures :users, :pages
  test_helper :login
  
  def setup
    @controller = Admin::ExportController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as(:developer)
  end

  def test_yaml
    get :yaml
    assert_kind_of Hash, YAML.load(@response.body)
    assert_equal 'text/yaml; charset=utf-8', @response.headers['Content-Type']
  end
end
