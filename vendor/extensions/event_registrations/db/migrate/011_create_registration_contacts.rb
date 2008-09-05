class CreateRegistrationContacts < ActiveRecord::Migration
  def self.up
    create_table :registration_contacts do |t|
      t.text :name
      t.text :title
      t.text :organization
      t.text :address
      t.text :city
      t.text :state
      t.text :zip
      t.text :country
      t.text :email
      t.text :phone
      t.timestamps
    end
  end

  def self.down
    drop_table :registration_contacts
  end
end
