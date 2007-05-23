require File.dirname(__FILE__) + '/../test_helper'

class FormsFormTest < Test::Unit::TestCase
  def test_create
    form = Forms::Form.create!(
      :model_name => "mymodel",
      :page_url   => "/my/page/is-right-here",
      :parameters => {:something => "to_save"}
    )
  end
end