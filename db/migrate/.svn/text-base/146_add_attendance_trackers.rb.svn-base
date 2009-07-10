class AddAttendanceTrackers < ActiveRecord::Migration
  def self.up
    create_table :attendance_trackers do |t|
        t.column :person_id, :integer
        t.column :group_id, :integer
        t.column :most_recent_attend, :datetime
        t.column :first_attend, :datetime
        t.column :count, :integer
    end
    
    #don't forget indexes!

      add_index :attendance_trackers, :person_id
      add_index :attendance_trackers, :group_id
      add_index :attendance_trackers, :most_recent_attend
      add_index :attendance_trackers, :first_attend
      add_index :attendance_trackers, :count
    
  end
  


  def self.down
    remove_index :attendance_trackers, :person_id
    remove_index :attendance_trackers, :group_id
    remove_index :attendance_trackers, :most_recent_attend
    remove_index :attendance_trackers, :first_attend
    remove_index :attendance_trackers, :count
    
    drop_table :attendance_trackers
    
  end
end
