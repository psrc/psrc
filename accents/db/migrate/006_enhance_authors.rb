class EnhanceAuthors < ActiveRecord::Migration
  def self.up
    add_column :authors, :website, :string
    add_column :authors, :notes, :text
  end

  def self.down
    remove_column :authors, :website
    remove_column :authors, :notes
  end
end
