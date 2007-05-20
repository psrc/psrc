class CreateForms < ActiveRecord::Migration
  def self.up
    create_table :forms do |t|
      t.column :parameters, :text
      t.column :model_name, :string
      t.column :page_url, :string
    end
  end
  
  def self.down
    drop_table :forms
  end
end