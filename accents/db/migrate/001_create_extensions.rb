class CreateExtensions < ActiveRecord::Migration
  def self.up
    create_table :extensions do |t|
      t.column :name, :string
      t.column :description, :text
      t.column :author, :string
      t.column :website_url, :string
      t.column :code_url, :string
      t.column :password, :string
    end
  end

  def self.down
    drop_table :extensions
  end
end
