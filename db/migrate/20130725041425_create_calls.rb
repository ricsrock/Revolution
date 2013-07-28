class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.string :from
      t.string :to
      t.string :sid
      t.string :rec_sid
      t.string :rec_url
      t.string :rec_duration
      t.integer :for_user_id

      t.timestamps
    end
    add_index :calls, :sid
    add_index :calls, :for_user_id
    add_index :calls, :rec_sid
    add_index :calls, :from
  end
end