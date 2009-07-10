class AddByPeople < ActiveRecord::Migration
  def self.up
    add_column :households, :created_by, :string
    add_column :households, :updated_by, :string
    add_column :people, :created_by, :string
    add_column :people, :updated_by, :string
  end

  def self.down
    remove_column :households, :created_by
    remove_column :households, :updated_by
    remove_column :people, :created_by
    remove_column :people, :updated_by
  end
end
