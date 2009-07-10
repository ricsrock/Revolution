class AddStatuses < ActiveRecord::Migration
  def self.up
    add_column :people, :attendance_status, :string
    add_column :households, :attendance_status, :string
    add_column :people, :contribution_status, :string
    add_column :households, :contribution_status, :string
  end

  def self.down
    remove_column :people, :attendance_status
    remove_column :households, :attendance_status
    remove_column :people, :contribution_status
    remove_column :households, :contribution_status
  end
end
