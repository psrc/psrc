require File.dirname(__FILE__) + '/../test_helper'

class PageContextTest < Test::Unit::TestCase
  fixtures :pages, :page_parts, :layouts, :snippets, :users
  test_helper :pages
  
  def setup
    @page = pages(:radius)
    @context = PageContext.new(@page)
    @parser = Radius::Parser.new(@context, :tag_prefix => 'r')
  end
    
  def test_initialize
    assert_equal(@page, @context.page)
  end
  
  def test_request_is_passed_around
    @context.define_tag "if_request" do |tag|
      tag.expand if tag.locals.page.request
    end
    assert_parse_output_match /^$/, '<r:if_request>tada!</r:if_request>'
    
    @page.request = ActionController::TestRequest.new
    assert_parse_output_match "tada!", '<r:if_request>tada!</r:if_request>'
    assert_parse_output_match "tada!", '<r:find url="/another/"><r:if_request>tada!</r:if_request></r:find>'
  end
  
  def test_response_is_passed_around
    @context.define_tag "if_response" do |tag|
      tag.expand if tag.locals.page.response
    end
    assert_parse_output_match /^$/, '<r:if_response>tada!</r:if_response>'
    
    @page.response = ActionController::TestResponse.new
    assert_parse_output_match "tada!", '<r:if_response>tada!</r:if_response>'
    assert_parse_output_match "tada!", '<r:find url="/another/"><r:if_response>tada!</r:if_response></r:find>'
  end

  private
    
    def assert_parse_output_match(regexp, input)
      output = @parser.parse(input)
      assert_match regexp, output
    end
    
end
