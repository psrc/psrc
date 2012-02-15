class AddBannerToEvent < ActiveRecord::Migration
  def self.up
    transaction do
      add_column :events, :banner_id, :integer
      add_index :events, :banner_id
    end
  end

  def self.down
    transaction do
      remove_column :events, :banner_id
    end
  end
end
