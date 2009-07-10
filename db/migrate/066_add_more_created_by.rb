class AddMoreCreatedBy < ActiveRecord::Migration
  def self.up
    add_column :jobs, :created_by, :string
    add_column :jobs, :updated_by, :string
    add_column :ministries, :created_by, :string
    add_column :ministries, :updated_by, :string
    add_column :departments, :updated_by, :string
    add_column :departments, :created_by, :string
    add_column :departments, :created_at, :datetime
    add_column :departments, :updated_at, :datetime
  end

  def self.down
    remove_column :jobs, :created_by
    remove_column :jobs, :updated_by
    remove_column :ministries, :created_by
    remove_column :ministries, :updated_by
    remove_column :departments, :updated_by
    remove_column :departments, :created
    remove_column :departments, :created_at
    remove_column :departments, :updated_at
  end
end
