class FixCommType < ActiveRecord::Migration
  def self.up
    rename_column :emails, :comm_type, :comm_type_id
    rename_column :phones, :comm_type, :comm_type_id
  end

  def self.down
    rename_column :emails, :comm_type_id, :comm_type
    rename_column :phones, :comm_type_id, :comm_type
  end
end
