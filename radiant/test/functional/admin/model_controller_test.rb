require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/model_controller'

#
# This test exercises the AbstractModelController by excercising the Layout
# model and the LayoutController views.
#
class Admin::AbstractModelControllerTest < Test::Unit::TestCase

  class TestController < Admin::AbstractModelController
    model :layout
    
    def rescue_action(e) raise e end
    
    def default_template_name(default_action_name = action_name)
      "#{Admin::LayoutController.controller_path}/#{default_action_name}"
    end
  end

  fixtures :users, :layouts
  test_helper :layouts
  
  def setup
    @controller = TestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user] = users(:existing)
    
    @layout_name = "Test Layout"
    
    destroy_test_layout
  end

  def test_index
    custom_routes do
      get :index
      assert_response :success
      layouts = assigns(:layouts)
      assert_kind_of Array, layouts
      assert_kind_of Layout, layouts.first
    end
  end

  def test_new
    custom_routes do
      get :new, :layout => layout_params
      assert_response :success
    
      @layout = assigns(:layout)
      assert_kind_of Layout, @layout
      assert_nil @layout.name
    end
  end
  def test_new__post
    custom_routes do
      post :new, :layout => layout_params
      assert_redirected_to layout_index_url
      assert_match /saved/, flash[:notice]
      assert_kind_of Layout, get_test_layout
    end
  end
  def test_new__post_with_invalid_layout
    custom_routes do
      post :new, :layout => layout_params(:name => nil)
      assert_response :success
      assert_match /error/, flash[:error]
      assert_nil get_test_layout
    end
  end

  def test_edit
    custom_routes do
      get :edit, :id => '1', :layout => layout_params
      assert_response :success
      assert_template 'admin/layout/new'
  
      @layout = assigns(:layout)
      assert_kind_of Layout, @layout
      assert_equal 'Home Page', @layout.name
    end
  end  
  def test_edit__post
    custom_routes do
      @layout = create_test_layout
      post :edit, :id => @layout.id, :layout => layout_params(:content => 'edited')
      assert_response :redirect
      assert_equal 'edited', get_test_layout.content
  
      # To-Do: Test what happens when an invalid page is submitted 
    end
  end
  
  def test_remove
    custom_routes do
      @layout = create_test_layout
      get :remove, :id => @layout.id 
      assert_response :success
      assert_equal @layout, assigns(:layout)
      assert_not_nil get_test_layout
    end
  end
  def test_remove__post
    custom_routes do
      @layout = create_test_layout
      post :remove, :id => @layout.id
      assert_nil get_test_layout
      assert_redirected_to layout_index_url
      assert_match /deleted/, flash[:notice]
    end
  end

  private
  
    def custom_routes
      with_routing do |set|
        set.draw { set.connect ':controller/:action' }
        yield
      end
    end
    
end