class AddMenuChoices < ActiveRecord::Migration
  def self.up
    transaction do
      create_table :menu_choices do |t|
        t.integer :event_option_id
        t.text :description
      end
    end
  end

  def self.down
  end
end
