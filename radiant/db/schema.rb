# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 15) do

  create_table "config", :force => true do |t|
    t.column "key",   :string, :limit => 40, :default => "", :null => false
    t.column "value", :string,               :default => ""
  end

  add_index "config", ["key"], :name => "key", :unique => true

  create_table "extension_meta", :force => true do |t|
    t.column "name",           :string
    t.column "schema_version", :integer, :default => 0
    t.column "enabled",        :boolean, :default => true
  end

  create_table "layouts", :force => true do |t|
    t.column "name",         :string,   :limit => 100
    t.column "content",      :text
    t.column "created_at",   :datetime
    t.column "updated_at",   :datetime
    t.column "created_by",   :integer
    t.column "updated_by",   :integer
    t.column "content_type", :string,   :limit => 40
    t.column "lock_version", :integer,                 :default => 0
  end

  create_table "page_parts", :force => true do |t|
    t.column "name",      :string,  :limit => 100
    t.column "filter_id", :string,  :limit => 25
    t.column "content",   :text
    t.column "page_id",   :integer
  end

  create_table "pages", :force => true do |t|
    t.column "title",        :string
    t.column "slug",         :string,   :limit => 100
    t.column "breadcrumb",   :string,   :limit => 160
    t.column "class_name",   :string,   :limit => 25
    t.column "status_id",    :integer,                 :default => 1,     :null => false
    t.column "parent_id",    :integer
    t.column "layout_id",    :integer
    t.column "created_at",   :datetime
    t.column "updated_at",   :datetime
    t.column "published_at", :datetime
    t.column "created_by",   :integer
    t.column "updated_by",   :integer
    t.column "virtual",      :boolean,                 :default => false, :null => false
    t.column "lock_version", :integer,                 :default => 0
  end

  create_table "snippets", :force => true do |t|
    t.column "name",         :string,   :limit => 100, :default => "", :null => false
    t.column "filter_id",    :string,   :limit => 25
    t.column "content",      :text
    t.column "created_at",   :datetime
    t.column "updated_at",   :datetime
    t.column "created_by",   :integer
    t.column "updated_by",   :integer
    t.column "lock_version", :integer,                 :default => 0
  end

  add_index "snippets", ["name"], :name => "name", :unique => true

  create_table "users", :force => true do |t|
    t.column "name",         :string,   :limit => 100
    t.column "email",        :string
    t.column "login",        :string,   :limit => 40,  :default => "",    :null => false
    t.column "password",     :string,   :limit => 40
    t.column "created_at",   :datetime
    t.column "updated_at",   :datetime
    t.column "created_by",   :integer
    t.column "updated_by",   :integer
    t.column "admin",        :boolean,                 :default => false, :null => false
    t.column "developer",    :boolean,                 :default => false, :null => false
    t.column "notes",        :text
    t.column "lock_version", :integer,                 :default => 0
  end

  add_index "users", ["login"], :name => "login", :unique => true

end
