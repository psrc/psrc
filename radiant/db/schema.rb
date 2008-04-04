# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 16) do

  create_table "config", :force => true do |t|
    t.string "key",   :limit => 40, :default => "", :null => false
    t.string "value",               :default => ""
  end

  add_index "config", ["key"], :name => "key", :unique => true

  create_table "extension_meta", :force => true do |t|
    t.string  "name"
    t.integer "schema_version", :default => 0
    t.boolean "enabled",        :default => true
  end

  create_table "layouts", :force => true do |t|
    t.string   "name",         :limit => 100
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.string   "content_type", :limit => 40
    t.integer  "lock_version",                :default => 0
  end

  create_table "page_parts", :force => true do |t|
    t.string  "name",      :limit => 100
    t.string  "filter_id", :limit => 25
    t.text    "content"
    t.integer "page_id"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "slug",         :limit => 100
    t.string   "breadcrumb",   :limit => 160
    t.string   "class_name",   :limit => 25
    t.integer  "status_id",                   :default => 1,     :null => false
    t.integer  "parent_id"
    t.integer  "layout_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "virtual",                     :default => false, :null => false
    t.integer  "lock_version",                :default => 0
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"
  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"

  create_table "snippets", :force => true do |t|
    t.string   "name",         :limit => 100, :default => "", :null => false
    t.string   "filter_id",    :limit => 25
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "lock_version",                :default => 0
  end

  add_index "snippets", ["name"], :name => "name", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name",         :limit => 100
    t.string   "email"
    t.string   "login",        :limit => 40,  :default => "",    :null => false
    t.string   "password",     :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "admin",                       :default => false, :null => false
    t.boolean  "developer",                   :default => false, :null => false
    t.text     "notes"
    t.integer  "lock_version",                :default => 0
  end

  add_index "users", ["login"], :name => "login", :unique => true

end
