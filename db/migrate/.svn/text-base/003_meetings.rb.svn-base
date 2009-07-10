class Meetings < ActiveRecord::Migration
  def self.up
    create_table :meetings do |t|
      t.column :instance_id, :integer
      t.column :group_id, :integer
      t.column :room_id, :integer
    end
  end

  def self.down
    drop_table :meetings
  end
end
