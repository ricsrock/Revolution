class AddAutoGroups < ActiveRecord::Migration
  def self.up
    create_table :auto_groups do |t|
      t.column :instance_type_id, :integer
      t.column :group_id, :integer
    end
  end

  def self.down
    drop_table :auto_groups
  end
end
