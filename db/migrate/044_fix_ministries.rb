class FixMinistries < ActiveRecord::Migration
  def self.up
    add_column :ministries, :department_id, :integer
    add_column :teams, :ministry_id, :integer
    add_column :jobs, :team_id, :integer
  end

  def self.down
  end
end
