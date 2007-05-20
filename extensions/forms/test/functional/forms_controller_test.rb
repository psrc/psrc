require File.dirname(__FILE__) + "/../test_helper"

FormsController # Why doesn't require 'forms_controller' work?
                # Because we don't have it in our require path

class FormsController; def rescue_action(e) raise e end; end

class FormsControllerTest < Test::Unit::TestCase
  test_helper :pages
  
  def setup
    @controller = FormsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @page = create_test_page({
      :title => "Forms",
      :slug => 'form-using-page',
      :status_id => 100
    })
    @page.parts.create!(:name => "body", :content => "Render Me!")
  end
  
  def test_create
    assert_difference Forms::Simple, :count do
      post :create, :form_memento => "signup:/form-using-page/", :signup => {}
      assert_match(/Render Me!/, @response.body)
    end
  end
end
