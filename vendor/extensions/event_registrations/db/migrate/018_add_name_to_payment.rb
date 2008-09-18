class AddNameToPayment < ActiveRecord::Migration
  def self.up
    add_column :payments, :name, :string
  end

  def self.down
    remove_column :payments, :name, :string
  end
end
