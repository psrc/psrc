class AddLayoutToEvent < ActiveRecord::Migration
  def self.up
    transaction do
      add_column :events, :layout, :string
      Event.update_all "layout = 'prosperity'"
    end
  end

  def self.down
    remove_column :events, :layout
  end
end
