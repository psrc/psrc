require File.dirname(__FILE__) + "/../test_helper"
require "ostruct"

FormsController # Why doesn't require 'forms_controller' work?
                # Because we don't have it in our require path

class FormsController; def rescue_action(e) raise e end; end

class FormsControllerTest < Test::Unit::TestCase
  class MyFormAction < Forms::Action
    attr_accessor :form, :verb
    def perform(verb, form)
      @verb = verb
      @form = form
    end
  end

  class MyModel < OpenStruct
    class << MyModel
      def create!(attributes)
        returning new(attributes) do |inst| instances << inst end
      end
      def instances
        @instances ||= []
      end
    end
  end

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
    
    saveme = Forms::Meta::Form.create!(:name => "saveme")
    saveme.fields.create!(:type => "text", :name => "stuff", :required => true)
  end
  
  def tear_down
    MyFormAction.form = MyFormAction.verb = nil
  end
  
  def test_create_transient_form
    post :create, :form_memento => "transient:signup:/form-using-page/", :signup => {:stuff => "Hi!"}
    assert_match(/Render Me!/, @response.body)
    assert_equal :post, MyFormAction.verb
    assert_equal "Hi!", MyFormAction.form.parameters[:stuff]
  end

  def test_create_meta_form
    assert_difference Forms::Form, :count do
      post :create, :form_memento => "meta:saveme:/form-using-page/", :saveme => {:stuff => "Hi!"}
      assert_match(/Render Me!/, @response.body)
      assert_equal :post, MyFormAction.verb
      assert_equal "Hi!", MyFormAction.form.stuff
    end
  end

  def test_create_model_form
    assert_difference MyModel.instances, :size do
      post :create, :form_memento => "model:forms_controller_test/my_model:/form-using-page/", :my_model => {:stuff => "Hi!"}
      assert_match(/Render Me!/, @response.body)
      assert_equal :post, MyFormAction.verb
      assert_equal "Hi!", MyFormAction.form.stuff
    end
  end
end
