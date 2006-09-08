require File.dirname(__FILE__) + '/../../test_helper'

class MarkdownFilterTest < Test::Unit::TestCase

  def test_registered_id
    assert_equal 'Markdown', MarkdownFilter.registered_id
  end

  def test_filter
    markdown = MarkdownFilter.new
    assert_equal '<p><strong>strong</strong></p>', markdown.filter('**strong**')
  end
  
  def test_filter_with_quotes
    markdown = MarkdownFilter.new
    assert_equal("<h1>Radiant&#8217;s &#8220;filters&#8221; rock!</h1>", 
      markdown.filter("# Radiant's \"filters\" rock!"))
  end

end