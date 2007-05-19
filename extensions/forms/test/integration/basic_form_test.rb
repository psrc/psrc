require File.dirname(__FILE__) + '/../test_helper'

class BasicFormTest < ActionController::IntegrationTest
  test_helper :pages
  
  def test_form
    render_form :form_content
    assert_select "form[action=/forms/]"
    assert_select "form input[type=hidden][name=_form_model][value=__undefined__]"
    assert_select "form input[type=text][name=name]"
    assert_select "form input[type=text][name=email]"
    assert_select "form input[type=text][name=subject]"
    assert_select "form textarea[name=message]"
    assert_select "form input[type=submit]"
  end
  
  def test_form_for
    render_form :form_for_content
    assert_select "form[action=/forms/]"
    assert_select "form input[type=hidden][name=_form_model][value=comments]"
  end
  
  def test_model_form_for
    render_form :model_form_for_content
    assert_select "form[action=/forms/]"
    assert_select "form input[type=hidden][name=_form_model][value=signup]"
    assert_select("form input[type=text]") { assert_select "[name=?]", /signup\[first_name\]/ }
    assert_select "form input[type=submit]"
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
  
  def form_for_content
    %{
      <r:form for="comments" />
    }
  end
  
  protected
    def render_form(content)
      @page = create_test_page({
        :title => "Forms",
        :slug => 'forms',
        :status_id => 100
      })
      @page.parts.create!(:name => "body", :content => self.send(content))
      get "/forms"
    end
end
