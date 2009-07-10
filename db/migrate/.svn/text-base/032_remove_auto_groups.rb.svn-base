class RemoveAutoGroups < ActiveRecord::Migration
  def self.up
    remove_column :instances, :auto_create
    remove_column :groups, :auto_create
  end

  def self.down
  end
end
