class AddEventIdToRegistration < ActiveRecord::Migration
  def self.up
    transaction do
      add_column :registrations, :event_id, :integer
      Registration.find(:all).each do |r|
        r.update_attribute :event_id, r.registration_groups.first.event_option.event.id
      end
    end
  end

  def self.down
    remove_column :registrations, :event_id, :integer
  end
end
