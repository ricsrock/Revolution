class FixDepartments < ActiveRecord::Migration
  def self.up
    add_column :departments, :name, :string
    add_column :ministries, :name, :string
    add_column :teams, :name, :string
  end

  def self.down
  end
end
