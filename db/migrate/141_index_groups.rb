class IndexGroups < ActiveRecord::Migration
  def self.up
    add_index :groups, :name
    add_index :groups, :parent_id
    add_index :groups, :lft
    add_index :groups, :rgt
    add_index :groups, :deleted_at
    add_index :groups, :tree_id
  end

  def self.down
  end
end
