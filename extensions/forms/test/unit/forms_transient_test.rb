require File.dirname(__FILE__) + '/../test_helper'

class FormsTransientTest < Test::Unit::TestCase
  def test_new
    form = Forms::Transient.new(Forms::Memento.new("transient:mymodel:/my/page/is-right-here"), {})
    assert_equal "mymodel", form.model_name
    assert_equal "/my/page/is-right-here", form.page_url

    form = Forms::Transient.new(Forms::Memento.new(":mymodel:/my/page/is-right-here"), :something => "value")
    assert_equal "value", form.something
  end
end