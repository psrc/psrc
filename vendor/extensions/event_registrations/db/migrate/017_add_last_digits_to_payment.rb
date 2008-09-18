class AddLastDigitsToPayment < ActiveRecord::Migration
  def self.up
    add_column :payments, :last_digits, :string
  end

  def self.down
    remove_column :payments, :last_digits, :string
  end
end
