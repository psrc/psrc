require File.dirname(__FILE__) + '/../../test_helper'

class ArchiveDayIndexBehaviorTest < Test::Unit::TestCase
  fixtures :pages
  test_helper :archive_index, :behavior_render

  def setup
    @page = pages(:day_index)
  end

  def test_children_tag
    assert_renders 'article ', '<r:archive:children:each><r:slug /> </r:archive:children:each>', '/archive/2000/06/09/'
    assert_renders 'article ', '<r:archive:children:each><r:slug /> </r:archive:children:each>', '/archive/2000/06/09'
  end
  
  include ArchiveIndexTests
end