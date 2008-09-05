class AddGroupName < ActiveRecord::Migration
  def self.up
    add_column :registration_groups, :group_name, :text
  end

  def self.down
    remove_column :registration_groups, :group_name
  end
end
