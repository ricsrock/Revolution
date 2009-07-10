class Instances < ActiveRecord::Migration
  def self.up
    create_table :instances do |t|
      t.column :instance_type_id, :integer
      t.column :event_id, :integer
      t.column :auto_create, :boolean
    end
  end

  def self.down
    drop_table :instances
  end
end
