class ExtractAuthorStuff < ActiveRecord::Migration
  def self.up
    remove_column :extensions, :author
    remove_column :extensions, :password
  end

  def self.down
    add_column :extensions, :author, :string
    add_column :extensions, :password, :string
  end
end
