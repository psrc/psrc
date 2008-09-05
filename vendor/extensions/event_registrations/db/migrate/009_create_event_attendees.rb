class CreateEventAttendees < ActiveRecord::Migration
  def self.up
    create_table :event_attendees do |t|
      t.integer :registration_group_id, :null => false
      t.text :name
      t.text :email
      t.boolean :vegetarian
      t.timestamps
    end
  end

  def self.down
    drop_table :event_attendees
  end
end
