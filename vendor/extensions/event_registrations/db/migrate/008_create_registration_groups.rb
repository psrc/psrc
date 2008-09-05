class CreateRegistrationGroups < ActiveRecord::Migration
  def self.up
    create_table :registration_groups do |t|
      t.integer :registration_id, :null => false
      t.integer :event_option_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :registration_groups
  end
end
