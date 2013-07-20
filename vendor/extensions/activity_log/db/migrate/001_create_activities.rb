class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer :user_id
      t.string  :action
      t.integer :subject_id
      t.string  :subject_type
      t.text    :subject_attributes
      t.text    :subject_changes
      t.timestamps
    end

    add_index :activities, :user_id
    add_index :activities, [:subject_id, :subject_type]
  end

  def self.down
    drop_table :activities
  end
end
