require File.dirname(__FILE__) + '/../spec_helper'

# TODO: More test translation from test_show_page__page_processed on

describe SiteController, "in general" do
  scenario :pages

  it "should parse pages with Radius" do
    get :show_page, :url => 'radius'
    response.should be_success
    response.body.should == 'Radius body.'
  end

  it "should not have a no cache header" do
    get :show_page, :url => "/"
    response.headers.keys.should_not include('Cache-Control')
  end
  
end

describe SiteController, "given the following pages exists they will be found and rendered" do

  scenario :pages

  it "the home page" do
    get :show_page, :url => ''
    response.should be_success
    response.body.should == 'Hello world!'
  end

  it "a page one level deep" do
    get :show_page, :url => 'first/'
    response.should be_success
    response.body.should == 'First body.'
  end

  it "a page two levels deep" do
    get :show_page, :url => 'parent/child/'
    response.should be_success
    response.body.should == 'Child body.'
  end
  
end

describe SiteController, "given no pages exist" do 

  before :all do
    # Page.stub!(:find_by_url).with(:url, :live).and_return(nil)
  end

  it "should redirect to admin welcome page" do
    get :show_page, :url => '/'
    response.should redirect_to(:controller => 'admin/welcome')
  end

end

describe SiteController, "given a request for an existing but not pubished page" do
  scenario :pages
  
  it "should display the page when a dev site isn't specified in config and the url of the request begins with 'dev.'" do
    request.host = 'dev.site.com'
    ['draft', 'hidden'].each do |url|
      get :show_page, :url => url
      response.should be_success
    end
  end

  it "should display the page when the dev site is specified in config and the request is for that site" do
    controller.config = { 'dev.host' => 'mysite.com'  }       
    request.host = 'mysite.com'    
    ['draft', 'hidden'].each do |url|
      get :show_page, :url => url
      response.should be_success
    end
  end  

  it "should not display the page for a request url which begins with 'dev.' if a specific site has been set in config" do 
    controller.config = { 'dev.host' => 'mysite.com'  }       
    request.host = 'dev.site.com'
    ['draft', 'hidden'].each do |url|
      get :show_page, :url => url
      response.headers["Status"].should == "404 Not Found"      
    end
  end
  
end

describe SiteController, "given a request for a non-existant page" do
  scenario :pages

  it "should render the 'page not found' template" do
    get :show_page, :url => 'a/non-existant/page'
    response.headers["Status"].should == "404 Not Found"
    response.should render_template('site/not_found')
  end
  
  it "should render a custom 404 page" 

end

