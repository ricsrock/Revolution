class AddAttendCounts < ActiveRecord::Migration
  def self.up
    add_column :people, :attend_count, :integer
    add_column :households, :attend_count, :integer
  end

  def self.down
    remove_column :people, :attend_count
    remove_column :households, :attend_count
  end
end
