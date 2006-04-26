require File.dirname(__FILE__) + '/../../test_helper'

class ArchiveYearIndexBehaviorTest < Test::Unit::TestCase
  fixtures :pages
  test_helper :archive_index, :behavior_render
  
  def setup
    @page = pages(:year_index)
  end
  
  def test_children_tag
    assert_renders 'article article-3 article-4 ', '<r:archive:children:each><r:slug /> </r:archive:children:each>', '/archive/2000/'
    assert_renders 'article article-3 article-4 ', '<r:archive:children:each><r:slug /> </r:archive:children:each>', '/archive/2000'
  end
  
  include ArchiveIndexTests
end