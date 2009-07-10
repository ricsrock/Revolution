class IndexEnrollments < ActiveRecord::Migration
  def self.up
    add_index :enrollments, :person_id
    add_index :enrollments, :group_id
    add_index :enrollments, :start_time
    add_index :enrollments, :end_time
    add_index :involvements, :person_id
    add_index :involvements, :job_id
    add_index :involvements, :start_date
    add_index :involvements, :end_date
    add_index :follow_ups, :contact_id
    add_index :follow_ups, :created_at
  end

  def self.down
  end
end
