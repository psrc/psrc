class AddFieldsToRegistration < ActiveRecord::Migration
  def self.up
    transaction do
      add_column :registrations, :registration_set,     :text
      add_column :registrations, :registration_contact, :text
      add_column :registrations, :event_option_id,      :integer
    end
  end

  def self.down
    transaction do
      remove_column :registrations, :registration_set
      remove_column :registrations, :registration_contact
    end
  end
end
