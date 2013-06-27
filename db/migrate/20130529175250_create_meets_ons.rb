class CreateMeetsOns < ActiveRecord::Migration
  def change
    create_table :meets_ons do |t|
      t.integer :group_id
      t.integer :weekday_id

      t.timestamps
    end
    add_index :meets_ons, :group_id
    add_index :meets_ons, :weekday_id
  end
end