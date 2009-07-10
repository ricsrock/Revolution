class AddUserGroupScope < ActiveRecord::Migration
  def self.up
        add_column :users, :group_scope, :string
  end

  def self.down
        remove_column :users, :group_scope
  end
end
