class AddNestedStuff < ActiveRecord::Migration
  def self.up
    add_column :groups, :created_at, :datetime, :null => false
    add_column :groups, :updated_at, :datetime, :null => false
    add_column :groups, :parent_id, :integer
    add_column :groups, :lft, :integer, :null => false
    add_column :groups, :rgt, :integer, :null => false
    add_column :groups, :created_by, :string
    add_column :groups, :updated_by, :string
  end

  def self.down
    remove_column :groups, :created_at
    remove_column :groups, :updated_at
    remove_column :parent_id, :integer
    remove_column :groups, :lft
    remove_column :groups, :rgt
    remove_column :groups, :created_by
    remove_column :groups, :updated_by
  end
end