#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/environment'

def announce(something)
  print "#{something}..."
  yield
  puts "OK"
end

announce "Creating database" do
  puts
  ActiveRecord::Schema.define(:version => 8) do
    create_table "config", :force => true do |t|
      t.column "key", :string, :limit => 40, :default => "", :null => false
      t.column "value", :string, :default => ""
    end
    add_index "config", ["key"], :name => "key", :unique => true

    create_table "layouts", :force => true do |t|
      t.column "name", :string, :limit => 100
      t.column "content", :text
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

announce "Creating the user 'admin' with password 'radiant'" do
  @admin = User.create :name => 'Administrator', :login => 'admin', :password => 'radiant', :password_confirmation => 'radiant', :admin => true
  @admin = User.find(@admin.id)
  UserActionObserver.current_user = @admin
  @admin.created_by = @admin
  @admin.password = 'radiant'
  @admin.password_confirmation = 'radiant'
  @admin.save
end

announce "Initializing configuration" do
  Radiant::Config['admin.title'   ] = 'Radiant CMS'
  Radiant::Config['admin.subtitle'] = 'Publishing for Small Teams'
  Radiant::Config['default.parts' ] = 'body, extended'
end

announce "Create initial layout" do
  @layout = Layout.create :name => 'Normal', :content => <<-HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
  "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>
  <head>
    <title><r:title /></title>
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

announce "Creating home page" do
  @home_page = Page.create :title => 'Home Page', :slug => '/', :breadcrumb => 'Home', :status_id => 100, :layout => @layout
  PagePart.create :name => 'body', :content => <<-HTML, :page => @home_page
<r:find url="/articles/">
<r:children:each limit="5" order="desc">
<div class="entry">
  <h3><r:link /></h3>
  <r:content />
  <r:if_content part="extended"><r:link anchor="extended">Continue Reading&#8230;</r:link></r:if_content>
</div>
</r:children:each>
</r:find>
  HTML
end
  
announce "Creating archives page" do
  @archives = Page.create :title => 'Articles', :slug => 'articles', :breadcrumb => 'Articles', :status_id => 100, :parent => @home_page, :layout => @layout, :behavior_id => 'Archive' 
  PagePart.create :name => 'body', :content => <<-HTML, :page => @archives
<ul>
<r:children:each order="desc">
  <li><r:link /></li>
</r:children:each>
</ul>
  HTML
end

announce "Creating first post" do
  @first_post = Page.create :title => 'First Post', :slug => 'first-post', :breadcrumb => 'First Post', :status_id => 100, :parent => @archives, :layout => @layout
  PagePart.create :name => 'body', :filter_id => 'Textile', :content => <<-HTML, :page => @first_post
This post uses "textile":http://www.textism.com/tools/textile/.
  HTML
end

announce "Creating second post" do
  @second_post = Page.create :title => 'Second Post', :slug => 'second-post', :breadcrumb => 'Second Post', :status_id => 100, :parent => @archives, :layout => @layout
  PagePart.create :name => 'body', :filter_id => 'Markdown', :content => <<-HTML, :page => @second_post
This post uses **Markdown**.
  HTML
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

puts "Finished."
