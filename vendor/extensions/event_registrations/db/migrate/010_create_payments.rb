class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :registration_id
      t.date    :estimated_payment_date
      t.integer :remote_payment_id
      t.string  :payment_method
      t.decimal :amount
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
