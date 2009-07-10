class AddCreatedAt < ActiveRecord::Migration
  def self.up
    add_column :emails, :updated_at, :datetime, :default => Time.now
    add_column :phones, :created_at, :datetime, :default => Time.now
    add_column :phones, :updated_at, :datetime, :default => Time.now
    add_column :teams, :created_at, :datetime, :default => Time.now
    add_column :teams, :updated_at, :datetime, :default => Time.now
    add_column :households, :created_at, :datetime, :default => Time.now
    add_column :households, :updated_at, :datetime, :default => Time.now
    add_column :ministries, :created_at, :datetime, :default => Time.now
    add_column :ministries, :updated_at, :datetime, :default => Time.now
    add_column :jobs, :created_at, :datetime, :default => Time.now
    add_column :jobs, :updated_at, :datetime, :default => Time.now
  end

  def self.down
    remove_column :emails, :updated_at
    remove_column :phones, :created_at
    remove_column :phones, :updated_at
    remove_column :teams, :created_at
    remove_column :teams, :updated_at
    remove_column :households, :created_at
    remove_column :households, :updated_at
    remove_column :ministries, :created_at
    remove_column :ministries, :updated_at
    remove_column :jobs, :created_at
    remove_column :jobs, :updated_at
  end
end
