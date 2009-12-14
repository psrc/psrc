class RegistrationEmailChanges < ActiveRecord::Migration
  def self.up
    transaction do
      add_column :events, :contact_email, :string

      %w( assistant_name assistant_email assistant_phone ).each do |attribute|
        add_column :registration_contacts, attribute, :text
      end

      Event.find(:all).each do |event|
        event.update_attribute :contact_email, event.default_contact_email
      end
    end
  end

  def self.down
  end
end
