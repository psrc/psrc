class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.date :start_date
      t.date :end_date
      t.text     :description
      t.text     :location
      t.text     :name
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
