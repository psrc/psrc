class AddUserAttributesToActivities < ActiveRecord::Migration
  def self.up
    remove_column :activities, :subject_changes
    add_column :activities, :user_attributes, :text
  end

  def self.down
    remove_column :activities, :user_attributes
    add_column :activities, :subject_changes, :text
  end
end
