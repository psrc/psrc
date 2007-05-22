class AddAuthorIdToExtension < ActiveRecord::Migration
  def self.up
    add_column :extensions, :author_id, :integer
  end

  def self.down
    remove_column :extensions, :author_id
  end
end
