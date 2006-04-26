#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/environment'

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

    now = Time.now

    puts "Creating the user 'admin' with the password 'radiant'..."
    admin = User.create :name => 'Administrator', :login => 'admin', :password => 'radiant', :password_confirmation => 'radiant', :admin => true, :created_at => now, :updated_at => now
    admin.created_by = admin
    admin.updated_by = admin
    admin.save

    puts "Initializing configuration..."
    Radiant::Config['admin.title'   ] = 'Radiant CMS'
    Radiant::Config['admin.subtitle'] = 'Publishing for Small Teams'
    Radiant::Config['default.parts' ] = 'body, extended'

    puts "Create initial layout..."
    layout = Layout.create :name => 'Normal', :content => <<-HTML, :created_at => now, :created_by => admin, :updated_at => now, :updated_by => admin
<html>
  <head><title><r:title /></title></head>
  <body>
    <r:snippet name="header" />
    <r:content />
    <r:content part="extended" />
    <r:snippet name="footer" />
  </body>
</html>
    HTML

    puts "Creating home page..."
    home_page = Page.create :title => 'Home Page', :slug => '/', :breadcrumb => 'Home', :status_id => 100, :parent_id => nil, :layout_id => layout, :created_at => now, :created_by => admin, :updated_at => now, :updated_by => admin
    PagePart.create :name => 'body', :content => 'This is body content for your home page.', :page => home_page

    puts "Creating snippets..."
    Snippet.create :name => 'header', :content => <<-HTML
<h1><r:title /></h1>
    HTML
    Snippet.create :name => 'footer', :content => <<-HTML
<hr />
<p>Powered by <a href="http://radiantcms.org/">Radiant CMS</a></p>
    HTML

end