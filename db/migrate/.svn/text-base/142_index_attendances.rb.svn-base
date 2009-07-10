class IndexAttendances < ActiveRecord::Migration
  def self.up
    add_index :attendances, :person_id
    add_index :attendances, :meeting_id
  end

  def self.down
  end
end
