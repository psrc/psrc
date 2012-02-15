class CreateEventBanners < ActiveRecord::Migration
  def self.up
    create_table :event_banners do |t|
      t.column :event_id, :integer
      t.column :size, :integer 
      t.column :content_type, :string
      t.column :filename, :string
      t.column :width, :string
      t.column :height, :integer
      t.timestamps
    end
    add_index :event_banners, :event_id
  end

  def self.down
    drop_table :event_banners
  end
end
