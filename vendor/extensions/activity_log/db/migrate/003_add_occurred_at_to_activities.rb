class AddOccurredAtToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :occurred_at, :datetime
    execute 'update activities set occurred_at = created_at;'
  end

  def self.down
    remove_column :activities, :occurred_at
  end
end
