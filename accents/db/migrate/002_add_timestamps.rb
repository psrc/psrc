class AddTimestamps < ActiveRecord::Migration
  def self.up
    add_column :extensions, :created_at, :datetime
    add_column :extensions, :updated_at, :datetime
  end

  def self.down
    remove_column :extensions, :created_at
    remove_column :extensions, :updated_at
  end
end
