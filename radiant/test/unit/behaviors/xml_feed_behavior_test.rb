require File.dirname(__FILE__) + '/../../test_helper'

class XMLFeedBehaviorTest < Test::Unit::TestCase
  test_helper :behavior_render

  def setup
    @page = Page.new(:slug => "\\")
    @page.behavior_id = 'XML Feed'
    @behavior = @page.behavior
  end
  
  def test_page_headers
    assert_equal 'text/xml', @behavior.page_headers['Content-Type']
  end
  
  def test_escape_html_tag
    assert_renders '&lt;strong&gt;a bold move&lt;/strong&gt;', '<r:escape_html><strong>a bold move</strong></r:escape_html>'
  end
  
  def test_rfc1123_date_tag
    @page.published_at = Date.new(2004, 5, 2)
    assert_renders 'Sun, 02 May 2004 04:00:00 GMT', '<r:rfc1123_date />'
  end
end