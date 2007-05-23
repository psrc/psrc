class CreateForms < ActiveRecord::Migration
  def self.up
    create_table :forms do |t|
      t.column :parameters, :text
      t.column :model_name, :string
      t.column :page_url,   :string
    end
    
    create_table :meta_forms do |t|
      t.column :name, :string
    end
    
    create_table :meta_fields do |t|
      t.column :form_id, :integer
      t.column :type, :string
      t.column :name, :string
      t.column :required, :boolean
    end
  end
  
  def self.down
    drop_table :forms, :meta_forms, :meta_fields
  end
end