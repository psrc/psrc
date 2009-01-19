class AddContactStuff < ActiveRecord::Migration
  def self.up
    transaction do
      add_column :events, :attendee_same_as_contact, :boolean
    end
  end

  def self.down
  end
end
