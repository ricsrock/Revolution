class AddStartDate < ActiveRecord::Migration
  def self.up
        add_column :involvements, :start_date, :date
        add_column :involvements, :end_date, :date
        add_column :enrollments, :start_date, :date
        add_column :enrollments, :end_date, :date
  end

  def self.down
        remove_column :involvements, :start_date
        remove_column :involvements, :end_date
        remove_column :enrollments, :start_date
        remove_column :enrollments, :end_date
  end
end
