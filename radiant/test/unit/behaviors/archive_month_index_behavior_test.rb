require File.dirname(__FILE__) + '/../../test_helper'

class ArchiveMonthIndexBehaviorTest < Test::Unit::TestCase
  fixtures :pages
  test_helper :archive_index, :behavior_render

  def setup
    @page = pages(:month_index)
  end

  def test_children_tag
    assert_renders 'article-2 article-3 ', '<r:archive:children:each><r:slug /> </r:archive:children:each>', '/archive/2000/06/'
    assert_renders 'article-2 article-3 ', '<r:archive:children:each><r:slug /> </r:archive:children:each>', '/archive/2000/06'
  end

  include ArchiveIndexTests
end