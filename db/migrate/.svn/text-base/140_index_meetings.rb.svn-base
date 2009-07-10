class IndexMeetings < ActiveRecord::Migration
  def self.up
    add_index :meetings, :group_id
    add_index :meetings, :instance_id
    add_index :meetings, :deleted_at
  end

  def self.down
  end
end
