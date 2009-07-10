class MoreDeletedAts < ActiveRecord::Migration
  def self.up
        add_column :rotations, :deleted_at, :datetime
        add_column :involvements, :deleted_at, :datetime
        add_column :contributions, :deleted_at, :datetime
        add_column :events, :deleted_at, :datetime
        add_column :instances, :deleted_at, :datetime
        add_column :meetings, :deleted_at, :datetime
        add_column :contacts, :deleted_at, :datetime
        add_column :batches, :deleted_at, :datetime
  end

  def self.down
        remove_column :rotations, :deleted_at
        remove_column :involvements, :deleted_at
        remove_column :contributions, :deleted_at
        remove_column :events, :deleted_at
        remove_column :instances, :deleted_at
        remove_column :meetings, :deleted_at
  end
end
