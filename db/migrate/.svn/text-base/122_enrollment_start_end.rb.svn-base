class EnrollmentStartEnd < ActiveRecord::Migration
  def self.up
        add_column :enrollments, :start_time, :datetime
        add_column :enrollments, :end_time, :datetime
        add_column :groups, :archived_on, :datetime
  end

  def self.down
        remove_column :enrollments, :start_time
        remove_column :enrollments, :end_time
        remove_column :groups, :archived_on
  end
end
