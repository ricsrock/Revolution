class AddTreeId < ActiveRecord::Migration
  def self.up
      add_column :groups, :tree_id, :integer
  end

  def self.down
  end
end
