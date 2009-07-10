class AddCheckinGroupCheckBox < ActiveRecord::Migration
  def self.up
    add_column :groups, :checkin_group, :boolean, :default => 1
  end

  def self.down
    remove_column :groups, :checkin_group
  end
end
