class CreateFuzzyBears < ActiveRecord::Migration
  def self.up
    create_table :fuzzy_bears do |t|
      t.column :name, :string
      t.column :birthday, :date
      t.column :weight, :integer
    end
  end

  def self.down
    drop_table :fuzzy_bears
  end
end
