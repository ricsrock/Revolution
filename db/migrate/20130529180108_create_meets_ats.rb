class CreateMeetsAts < ActiveRecord::Migration
  def change
    create_table :meets_ats do |t|
      t.integer :group_id
      t.integer :meeting_time_id

      t.timestamps
    end
    add_index :meets_ats, :group_id
    add_index :meets_ats, :meeting_time_id
  end
end