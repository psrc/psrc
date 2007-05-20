require File.dirname(__FILE__) + '/../test_helper'

class BasicFormTest < Test::Unit::TestCase
  test_helper :render
  test_helper :pages
  
  def test_form
    assert_renders form_content do
      assert_select "form[action=/forms/]"
      assert_select "form input[type=hidden][name=form_memento][value=:/form-using-page/]"
      assert_select "form input[type=text][name=name]"
      assert_select "form input[type=text][name=email]"
      assert_select "form input[type=text][name=subject]"
      assert_select "form textarea[name=message]"
      assert_select "form input[type=submit]"
    end
  end
  
  def test_form_for
    assert_renders %{<r:form for="comments" />} do
      assert_select "form[action=/forms/]"
      assert_select "form input[type=hidden][name=form_memento][value=comments:/form-using-page/]"
    end
  end
  
  def test_model_form_for
    assert_renders model_form_for_content do
      assert_select "form[action=/forms/]"
      assert_select "form input[type=hidden][name=form_memento][value=signup:/form-using-page/]"
      assert_select("form input[type=text]") { assert_select "[name=?]", /signup\[first_name\]/ }
      assert_select "form input[type=submit]"
    end
  end
  
  def form_content
    %{
      <r:form>
        Name: <r:text_field name="name" /><br />
        E-mail: <r:text_field name="email" /><br />
        Subject: <r:text_field name="subject" /><br />
        Message: <r:text_area name="message" /><br />
        Date: < r:date_field name="problem_date" /><br />
        <r:submit />
      </r:form>
    }
  end
  
  def model_form_for_content
    %{
      <r:model_form for="signup">
        <r:text_field on="first_name" />
        <r:submit />
      </r:model_form>
    }
  end
  
  protected
    def assert_renders_with_block(*args, &block)
      if block
        rendered = get_render_output(args[0], '/form-using-page')
        @response.body = rendered
        begin
          block.call
        rescue
          puts rendered
          raise
        end
      else
        assert_renders_without_block(*args)
      end
    end
    alias_method_chain :assert_renders, :block
  
    def setup_page_with_content_control(url = nil)
      @page = create_test_page({
        :title => "Forms",
        :slug => 'form-using-page',
        :status_id => 100
      })
      @page.controller = @controller = ActionController::Base.new
      @page.request = ActionController::TestRequest.new
      @page.request.request_uri = 'http://testhost.tld' + (url || @page.url)
      @page.response = @response = ActionController::TestResponse.new
    end
    alias_method_chain :setup_page, :content_control
end
