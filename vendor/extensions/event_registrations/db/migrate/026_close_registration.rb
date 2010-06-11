class CloseRegistration < ActiveRecord::Migration
  def self.up
    transaction do
      add_column :events, :registration_closed, :boolean
    end
  end

  def self.down
  end
end
