require File.dirname(__FILE__) + '/../../test_helper'

class SmartyPantsFilterTest < Test::Unit::TestCase

  def test_registered_id
    assert_equal 'SmartyPants', SmartyPantsFilter.registered_id
  end
  
  def test_filter
    smartypants = SmartyPantsFilter.new
    assert_equal("<h1 class=\"headline\">Radiant&#8217;s &#8220;filters&#8221; rock!</h1>", 
      smartypants.filter("<h1 class=\"headline\">Radiant's \"filters\" rock!</h1>"))
  end  

end