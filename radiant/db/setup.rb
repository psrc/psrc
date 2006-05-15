#!/usr/bin/env ruby

params = ARGV.map { |param| param.downcase.strip }
force = !!(params.delete('--force') || params.delete('-f') )
help = !!params.delete('--help')
env = params.delete('development') || params.delete('production') || params.delete('test')

if help or not params.empty?
  if not params.empty?
    puts "Invalid option."
    puts
  end
  puts "Usage: #{File.basename($0)} [options] environment"
  puts "Setup Radiant database for the appropriate environment."
  puts
  puts "Options:"
  puts "  --force    do not display the overwrite warning"
  puts "  --help     display this message"
  puts
  puts "For more information see http://radiantcms.org/."
  exit
end

RAILS_ENV = case env
when /production/i
  'production'
when /test/i
  'test'
else
  'development'
end

def announce(something)
  $defout.print "#{something}..."
  $defout.flush
  yield
  $defout.puts "OK"
end

puts "Execute `setup.rb --help` for more options."
puts

announce "Loading #{RAILS_ENV} environment" do
  require File.dirname(__FILE__) + '/../config/environment'
end

unless force
  print "\nWARNING! This script will overwrite any information currently stored in\n" + 
        "the database #{(ActiveRecord::Base.connection.current_database).inspect}. " + 
        "Are you sure you want to continue? [Yn] "
  case gets.strip.downcase
  when "yes", "y", ""
    puts
  when "no", "n"
    puts "Setup canceled."
    exit
  else
    puts "Invalid option."
    exit
  end
end

announce "Creating database" do
  puts
  ActiveRecord::Schema.define(:version => 9) do
    create_table "config", :force => true do |t|
      t.column "key", :string, :limit => 40, :default => "", :null => false
      t.column "value", :string, :default => ""
    end
    add_index "config", ["key"], :name => "key", :unique => true

    create_table "layouts", :force => true do |t|
      t.column "name", :string, :limit => 100
      t.column "content", :text
      t.column "content_type", :string, :limit => 40
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "created_by", :integer
      t.column "updated_by", :integer
    end

    create_table "page_parts", :force => true do |t|
      t.column "name", :string, :limit => 100
      t.column "filter_id", :string, :limit => 25
      t.column "content", :text
      t.column "page_id", :integer
    end

    create_table "pages", :force => true do |t|
      t.column "title", :string
      t.column "slug", :string, :limit => 100
      t.column "breadcrumb", :string, :limit => 160
      t.column "parent_id", :integer
      t.column "layout_id", :integer
      t.column "behavior_id", :string, :limit => 25
      t.column "status_id", :integer, :default => 1, :null => false
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "published_at", :datetime
      t.column "created_by", :integer
      t.column "updated_by", :integer
      t.column "virtual", :boolean, :default => false, :null => false
    end

    create_table "snippets", :force => true do |t|
      t.column "name", :string, :limit => 100, :default => "", :null => false
      t.column "filter_id", :string, :limit => 25
      t.column "content", :text
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "created_by", :integer
      t.column "updated_by", :integer
    end
    add_index "snippets", ["name"], :name => "name", :unique => true

    create_table "users", :force => true do |t|
      t.column "name", :string, :limit => 100
      t.column "email", :string
      t.column "login", :string, :limit => 40, :default => "", :null => false
      t.column "password", :string, :limit => 40
      t.column "admin", :boolean, :default => false, :null => false
      t.column "developer", :boolean, :default => false, :null => false
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "created_by", :integer
      t.column "updated_by", :integer
    end
    add_index "users", ["login"], :name => "login", :unique => true
  end
end

announce "Creating user 'admin' with password 'radiant'" do
  @admin = User.create :name => 'Administrator', :login => 'admin', :password => 'radiant', :password_confirmation => 'radiant', :admin => true
  @admin = User.find(@admin.id)
  UserActionObserver.current_user = @admin
  @admin.created_by = @admin
  @admin.password = 'radiant'
  @admin.password_confirmation = 'radiant'
  @admin.save
end

announce "Initializing configuration" do
  config = Radiant::Config
  config['admin.title'   ] = 'Radiant CMS'
  config['admin.subtitle'] = 'Publishing for Small Teams'
  config['default.parts' ] = 'body, extended'
end

announce "Creating main layout" do
  @layout = Layout.create :name => 'Normal', :content => <<-HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
  "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>
  <head>
    <title><r:title /></title>
    <link href="/rss/" rel="alternate" title="RSS" type="application/rss+xml" />
    <style type="text/css">
    <!--
      body {
        font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
        font-size: 80%;
      }
    -->
    </style>
  </head>
  <body>
    <r:snippet name="header" />
    <div id="content">
      <r:content />
      <div id="extended">
        <r:content part="extended" />
      </div>
    </div>
    <r:snippet name="footer" />
  </body>
</html>
  HTML
end

announce "Creating XML layout" do
  @xml_layout = Layout.create :name => 'XML Feed', :content_type => 'text/xml', :content => '<r:content />'
end

@page_parent = nil
@page_layout = @layout

def create_page(options)
  options.symbolize_keys!
  options = {
    :breadcrumb => options[:title],
    :slug => options[:title].strip.downcase.gsub(/\W+/, '-'),
    :status_id => 100,
    :layout => @page_layout,
    :parent => @page_parent
  }.merge(options)
  body = options.delete(:body)
  filter_id = options.delete(:filter_id)
  page = Page.create(options)
  PagePart.create(:page => page, :name => 'body', :filter_id => filter_id, :content => body)
  page
end

announce "Creating home page" do
  @home_page = create_page :title => 'Home Page', :slug => '/', :breadcrumb => 'Home', :body => <<-HTML
<r:find url="/articles/">
<r:children:each limit="5" order="desc">
<div class="entry">
  <h3><r:link /> <small><r:author /></small></h3>
  <r:content />
  <r:if_content part="extended"><r:link anchor="extended">Continue Reading&#8230;</r:link></r:if_content>
</div>
</r:children:each>
</r:find>
  HTML
  @page_parent = @home_page
end

announce "Creating file not found error page" do
  @page_missing_page = create_page :title => 'File Not Found', :behavior_id => 'Page Missing', :filter_id => 'Textile', :body => <<-HTML
The file you were looking for could not be found.

Attempted URL: @<r:attempted_url />@

It is possible that you typed the URL incorrectly or that you clicked on a bad link.

"<< Back to Home Page":/
  HTML
end

announce "Creating RSS feed for articles" do
  @rss_page = create_page :title => 'RSS Feed', :slug => 'rss', :layout => @xml_layout, :body => <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
  <channel>
    <title>Article RSS Feed</title>
    <link>http://your-web-site.com<r:url /></link>
    <language>en-us</language>
    <ttl>40</ttl>
    <description>The main blog feed for my Web site.</description>
    <r:find url="/articles/">
    <r:children:each limit="10">
        <item>
          <title><r:title /></title>
          <description><r:escape_html><r:content /></r:escape_html></description>
          <pubDate><r:rfc1123_date /></pubDate>
          <guid>http://your-web-site.com<r:url /></guid>
          <link>http://your-web-site.com<r:url /></link>
        </item>
    </r:children:each>
    </r:find>
  </channel>
</rss>
  XML
end

announce "Creating articles index page" do
  @archives = create_page :title => 'Articles', :behavior_id => 'Archive', :body => <<-HTML
<ul>
<r:children:each order="desc">
  <li><r:link /></li>
</r:children:each>
</ul>
  HTML
  @page_parent = @archives
end

announce "Creating first post" do
  @first_post = create_page :title => 'First Post', :filter_id => 'Textile', :body => <<-TEXTILE
This post uses "textile":http://www.textism.com/tools/textile/.
  TEXTILE
end

announce "Creating second post" do
  @second_post = create_page :title => 'Second Post', :filter_id => 'Markdown', :body => <<-MARKDOWN
This post uses **Markdown**.
  MARKDOWN
end

announce "Creating snippets" do
  Snippet.create :name => 'header', :content => <<-HTML
<div id="header">
  <h1><r:title /></h1>
</div>
<hr />
  HTML
  Snippet.create :name => 'footer', :content => <<-HTML
<hr />
<div id="footer">
  <p>Powered by <a href="http://radiantcms.org/">Radiant CMS</a></p>
</div>
  HTML
end

puts
puts "Finished."
