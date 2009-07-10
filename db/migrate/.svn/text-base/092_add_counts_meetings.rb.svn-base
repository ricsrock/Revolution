class AddCountsMeetings < ActiveRecord::Migration
  def self.up
    add_column :meetings, :leaders_count, :integer, :default => 0
    add_column :meetings, :participants_count, :integer, :default => 0
    add_column :meetings, :total_count, :integer, :default => 0
    add_column :instances, :car_count, :integer, :default => 0
    add_column :events, :total_count, :integer, :default => 0
    add_column :instances, :total_count, :integer, :default => 0
  end

  def self.down
    remove_column :meetings, :leaders_count
    remove_column :meetings, :participants_count
    remove_column :meetings, :total_count
    remove_column :instances, :car_count
    remove_column :events, :total_count
    remove_column :instances, :total_count
  end
end
