class AddPaymentToRegistration < ActiveRecord::Migration
  def self.up
    transaction do
      add_column :registrations, :payment,     :text
    end
  end

  def self.down
    transaction do
      remove_column :registrations, :payment
    end
  end
end
