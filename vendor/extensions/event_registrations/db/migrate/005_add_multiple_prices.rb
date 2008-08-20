class AddMultiplePrices < ActiveRecord::Migration
  def self.up
    add_column :event_options, :early_price, :decimal
    add_column :event_options, :early_price_date, :date
    rename_column :event_options, :price, :normal_price
  end

  def self.down
    remove_column :event_options, :early_price
    remove_column :event_options, :early_price_date
  end
end
