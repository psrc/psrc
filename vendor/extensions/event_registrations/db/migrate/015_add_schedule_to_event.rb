class AddScheduleToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :schedule, :text
  end

  def self.down
    remove_column :events, :schedule
  end
end
