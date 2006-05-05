require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/snippet_controller'

# Re-raise errors caught by the controller.
class Admin::SnippetController; def rescue_action(e) raise e end; end

class Admin::SnippetControllerTest < Test::Unit::TestCase
  fixtures :snippets, :users
  test_helper :snippets, :users, :caching

  def setup
    @controller = Admin::SnippetController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user] = users(:existing)
    @snippet_name = 'test-snippet'
    @cache = @controller.page_cache = FakePageCache.new
    destroy_test_snippet
    @snippet = create_test_snippet
  end

  def test_initialize
    @controller = Admin::SnippetController.new
    assert_kind_of PageCache, @controller.page_cache
  end

  def test_ancestors
    assert Admin::SnippetController.ancestors.include?(Admin::AbstractModelController)
  end

  def test_clears_cache_on_save
    post :edit, { :id => @snippet.id, :snippet => snippet_params(:content => 'edited') }
    assert_redirected_to snippet_index_url
    assert_equal true, @cache.cleared
  end
  
  def test_not_cleared_when_invalid
    post :edit, { :id => @snippet.id, :snippet => snippet_params(:name => 'Invalid Name') }
    assert_response :success
    assert_equal false, @cache.cleared
  end
  
end
