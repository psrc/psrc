require File.dirname(__FILE__) + "/../spec_helper"

describe ApplicationHelper do
  scenario :users

  before :each do
    Radiant::Initializer.run :initialize_default_admin_tabs
  end
  
  it "should have the Radiant::Config" do
    config.should == Radiant::Config
  end
  
  it "should use the default title if not configured" do
    title.should == "Radiant CMS"
  end
  
  it "should use the stored title if configured" do
    config['admin.title'] = "My Title"
    title.should == "My Title"
  end

  it "should use the default subtitle if not configured" do
    subtitle.should == "Publishing for Small Teams"
  end
  
  it "should use the stored title if configured" do
    config['admin.subtitle'] = "My Subtitle"
    subtitle.should == "My Subtitle"
  end
  
  it "should not be logged in before authentication" do
    should_receive(:current_user).and_return(nil)
    logged_in?.should be_false
  end
  
  it "should be logged in when authenticated" do
    should_receive(:current_user).and_return(users(:existing))
    logged_in?.should be_true
  end
  
  it "should create a button for a new model" do
    model = mock_model(Page)
    model.should_receive(:new_record?).and_return(true)
    should_receive(:submit_tag).with("Create Page", :class => 'button')
    save_model_button(model)
  end
  
  it "should create a button for an existing model" do
    model = mock_model(Page)
    model.should_receive(:new_record?).and_return(false)
    should_receive(:submit_tag).with("Save Changes", :class => 'button')
    save_model_button(model)
  end
  
  it "should create a save and continue button" do
    model = mock_model(Page)
    save_model_and_continue_editing_button(model).should =~ /name="continue"/
    save_model_and_continue_editing_button(model).should =~ /class="button"/
    save_model_and_continue_editing_button(model).should =~ /^<input/
  end
  
  it "should redefine pluralize without the count" do
    pluralize(1, "page").should == "page"
    pluralize(2, "page").should == "pages"
    pluralize(0, "page").should == "pages"
    pluralize(2, "ox", "oxen").should == "oxen"
  end
  
  it "should generate links for the admin navigation" do
    stub!(:current_user).and_return(users(:admin))
    links_for_navigation.should =~ Regexp.new("/admin/pages")
    links_for_navigation.should =~ Regexp.new(separator)
    links_for_navigation.should =~ Regexp.new("/admin/snippets")
    links_for_navigation.should =~ Regexp.new("/admin/layouts")
  end
  
  it "should hide admin links that should not be visible to the current user" do
    stub!(:current_user).and_return(users(:existing))
    links_for_navigation.should =~ Regexp.new("/admin/pages")
    links_for_navigation.should =~ Regexp.new(separator)
    links_for_navigation.should =~ Regexp.new("/admin/snippets")
    links_for_navigation.should_not =~ Regexp.new("/admin/layouts")
  end
  
  it "should render a separator" do
    separator.should == %{ <span class="separator"> | </span> }
  end
  
  it "should determine whether a given url matches the current url" do
    request = mock("request")
    stub!(:request).and_return(request)
    request.stub!(:request_uri).and_return("/foo/bar")
    current_url?("/foo/bar/").should_not be_false
    current_url?("/foo//bar").should_not be_false
    current_url?("/baz/bam").should_not be_true
    current_url?(:controller => "admin/page", :action => "index").should_not be_true
  end
  
  it "should clean a url" do
    clean("/foo/////bar").should == "/foo/bar"
    clean("/blah/").should == "/blah"
  end
  
  it "should render an admin navigation link" do
    request = mock("request")
    stub!(:request).and_return(request)
    request.stub!(:request_uri).and_return("/admin/pages")
    nav_link_to("Pages", "/admin/pages").should =~ /<strong>/
    nav_link_to("Snippets", "/admin/snippest").should_not =~ /<strong>/
  end
  
  it "should determine whether the current user is an admin" do
    should_receive(:current_user).at_least(1).times.and_return(users(:admin))
    admin?.should be_true
  end
  
  it "should determine whether the current user is a developer" do
    should_receive(:current_user).at_least(1).times.and_return(users(:developer))
    developer?.should be_true
  end
  
  it "should render a Javascript snippet that focuses a given field" do
    focus('joe').should =~ Regexp.new(Regexp.quote("activate('joe')"))
  end
  
  it "should render an updated timestamp for a model" do
    model = mock_model(Page)
    model.should_receive(:new_record?).and_return(false)
    model.should_receive(:updated_by).and_return(users(:admin))
    model.should_receive(:updated_at).and_return(Time.local(2008, 3, 30, 10, 30))
    updated_stamp(model).should == %{<p style="clear: left"><small>Last updated by admin at 10:30 <small>AM</small> on March 30, 2008</small></p>}
  end
  
  it "should render a timezone-adjusted timestamp" do
    timestamp(Time.local(2008, 3, 30, 10, 30)).should == "10:30 <small>AM</small> on March 30, 2008"
  end
  
  it "should determine whether a meta area item should be visible" do
    meta_visible(:meta_more).should be_nil
    meta_visible(:meta_less).should == ' style="display: none"'
    meta_visible(:meta).should == ' style="display: none"'
  end
  
  it "should not have meta errors" do
    meta_errors?.should be_false
  end
  
  it "should render a Javascript snippet to toggle the meta area" do
    toggle_javascript_for("joe").should == "Element.toggle('joe'); Element.toggle('more-joe'); Element.toggle('less-joe');"
  end
  
  it "should render an image tag with a default file extension" do
    should_receive(:image_tag).with("admin/plus.png", {})
    image("plus")
  end
  
  it "should render an image submit tag with a default file extension" do
    should_receive(:image_submit_tag).with("admin/plus.png", {})
    image_submit("plus")
  end
  
  it "should provide the admin object" do
    admin.should == Radiant::AdminUI.instance
  end
end