class AddOrganizationToEventAttendees < ActiveRecord::Migration
  def self.up
    add_column :event_attendees, :organization, :text
  end

  def self.down
    remove_column :event_attendees, :organization
  end
end
