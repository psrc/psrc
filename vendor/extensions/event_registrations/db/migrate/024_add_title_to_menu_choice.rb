class AddTitleToMenuChoice < ActiveRecord::Migration
  def self.up
    transaction do
      add_column :menu_choices, :title, :string
    end
  end

  def self.down
  end
end
