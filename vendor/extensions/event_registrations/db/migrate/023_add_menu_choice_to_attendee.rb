class AddMenuChoiceToAttendee < ActiveRecord::Migration
  def self.up
    transaction do
      add_column :event_attendees, :menu_choice_id, :integer
    end
  end

  def self.down
  end
end
