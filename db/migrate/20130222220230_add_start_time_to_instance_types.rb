class AddStartTimeToInstanceTypes < ActiveRecord::Migration
  def change
    add_column :instance_types, :start_time, :datetime
    add_index :instance_types, :start_time
    remove_column :instances, :start_time
  end
end