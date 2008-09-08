class RememberContact < ActiveRecord::Migration
  def self.up
    add_column :registrations, :registration_contact_id, :integer
  end

  def self.down
    remove_column :registrations, :registration_contact_id
  end
end
