class CreateEventOptions < ActiveRecord::Migration
  def self.up
    create_table :event_options do |t|
      t.integer :event_id, :null => false
      t.text :description, :null => false
      t.decimal :price
      t.integer :max_number_of_attendees
      t.timestamps
    end
  end

  def self.down
    drop_table :event_options
  end
end
