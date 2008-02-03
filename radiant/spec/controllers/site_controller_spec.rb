require File.dirname(__FILE__) + '/../spec_helper'

describe SiteController, "routes page requests" do
  # integrate_views
  scenario :pages

  before :each do
  end
  
  it "should find and render home page" do
    get :show_page, :url => ''
    response.should be_success
    response.body.should == 'Hello world!'
  end

  it "should find a page one level deep" do
    get :show_page, :url => 'first/'
    response.should be_success
    response.body.should == 'First body.'
  end

  it "should find a page two levels deep" do
    get :show_page, :url => 'parent/child/'
    response.should be_success
    response.body.should == 'Child body.'
  end

  it "should show page not found" do
    get :show_page, :url => 'a/non-existant/page'
    response.headers["Status"].should == "404 Not Found"
    response.should render_template('site/not_found')
  end

  it "should redirect to admin if missing root" do
    Page.should_receive(:find_by_url).and_raise(Page::MissingRootPageError)
    get :show_page, :url => '/'
    response.should redirect_to(welcome_url)
  end
  
  it "should parse pages with Radius" do
    get :show_page, :url => 'radius'
    response.should be_success
    response.body.should == 'Radius body.'
  end
  
  it "should redirect to 404 if page is not published status" do
    ['draft', 'hidden'].each do |url|
      get :show_page, :url => url
      response.should be_missing
      response.should render_template('site/not_found')
    end    
    # # validates the custom 404 page is rendered
    # get :show_page, :url => "/gallery/gallery_draft/"
    # response.should be_missing
    # response.should_not render_template('site/not_found')
  end

  it "should display draft and hidden pages on dev site" 
  # do
  #   @request.host = 'dev.site.com'
  #   ['draft', 'hidden'].each do |url|
  #     get :show_page, :url => url
  #     assert_response :success, "url: #{url}"
  #   end
  # end
  # 
  it "should be on dev site in config" 
  # do
  #   @controller.config = { 'dev.host' => 'mysite.com'  }
  #   
  #   @request.host = 'mysite.com'
  #   ['draft', 'hidden'].each do |url|
  #     get :show_page, :url => url
  #     assert_response :success, "url: #{url}"
  #   end
  #   
  #   @request.host = 'dev.site.com' # should function like live site because of config
  #   ['draft', 'hidden'].each do |url|
  #     get :show_page, :url => url
  #     assert_response :missing, "url: #{url}"
  #   end
  # end
  # 
  it "should not have no cache header"
  # do
  #   get :show_page, :url => '/'
  #   assert_equal false, @response.headers.keys.include?('Cache-Control')
  # end
  
end
