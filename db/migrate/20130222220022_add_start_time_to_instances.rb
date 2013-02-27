class AddStartTimeToInstances < ActiveRecord::Migration
  def change
    add_column :instances, :start_time, :datetime
    add_index :instances, :start_time
  end
end