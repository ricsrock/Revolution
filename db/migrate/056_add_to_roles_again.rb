class AddToRolesAgain < ActiveRecord::Migration
  def self.up
    add_column :roles, :description, :text
  end

  def self.down
    remove_column :roles, :description
  end
end
