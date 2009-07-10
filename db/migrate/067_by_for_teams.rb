class ByForTeams < ActiveRecord::Migration
  def self.up
    add_column :teams, :created_by, :string
    add_column :teams, :updated_by, :string
  end

  def self.down
    remove_column :teams, :created_by
    remove_column :teams, :updated_by
  end
end
