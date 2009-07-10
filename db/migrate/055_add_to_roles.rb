class AddToRoles < ActiveRecord::Migration
  def self.up
    add_column :roles, :alias, :string
  end

  def self.down
    remove_column :roles, :alias
  end
end
