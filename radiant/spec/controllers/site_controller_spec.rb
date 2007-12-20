require File.dirname(__FILE__) + '/../spec_helper'

# NOTE: This was the previous schema 
# describe SiteController, "routes page requests" do
# it "should find and render home page" do
# it "should find a page one level deep" do
# it "should find a page two levels deep" do
# it "should show page not found" do
# it "should redirect to admin if missing root" do
# it "should parse pages with Radius" do
# it "should redirect to 404 if page is not published status" do
# Pending
#   it "should display draft and hidden pages on dev site" 
#   it "should be on dev site in config" 
#   it "should not have no cache header"

# TODO: More test translation from test_show_page__page_processed

describe SiteController do

  scenario :pages
  
  it "should render page not found template when a non-existant page is requested" do
    get :show_page, :url => 'a/non-existant/page'
    response.headers["Status"].should == "404 Not Found"
    response.should render_template('site/not_found')
  end
  
  it "should parse pages with Radius" do
    get :show_page, :url => 'radius'
    response.should be_success
    response.body.should == 'Radius body.'
  end
  
  it "should redirect to 404 if page is not published status" do
    ['draft', 'hidden'].each do |url|
      get :show_page, :url => url
      response.headers["Status"].should == "404 Not Found"
      response.should render_template('site/not_found')
    end    
  end
  
  it "should render a custom 404 page" 
  
  it "should display draft and hidden pages on dev site" do
    request.host = 'dev.site.com'
    ['draft', 'hidden'].each do |url|
      get :show_page, :url => url
      response.should be_success
    end
  end
  
  it "won't display dev pages to dev. url if dev site has been specified in config" do
    controller.config = { 'dev.host' => 'mysite.com'  }       
    request.host = 'mysite.com'    
    ['draft', 'hidden'].each do |url|
      get :show_page, :url => url
      response.should be_success
    end
  end  
  
  it "should function like live site because of config" do
    controller.config = { 'dev.host' => 'mysite.com'  }       
    request.host = 'dev.site.com'
    ['draft', 'hidden'].each do |url|
      get :show_page, :url => url
      response.headers["Status"].should == "404 Not Found"      
    end
  end
  
  it "should not have no cache header" do
    get :show_page, :url => "/"
    response.headers.keys.should_not include('Cache-Control')
  end
  
end

describe SiteController, "will find and render" do

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

describe SiteController, "Given no pages exist" do 

  # before :all do
  #   Page.stub!(:find)
  # end

  it "should redirect to admin" 
  # do
  #   get :show_page, :url => '/'
  #   response.should redirect_to(:controller => 'admin/welcome')
  # end

end


