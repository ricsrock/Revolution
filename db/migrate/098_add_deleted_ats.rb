class AddDeletedAts < ActiveRecord::Migration
  def self.up
        add_column :people, :deleted_at, :datetime
        add_column :households, :deleted_at, :datetime
        add_column :groups, :deleted_at, :datetime
        add_column :jobs, :deleted_at, :datetime
        add_column :teams, :deleted_at, :datetime
        add_column :ministries, :deleted_at, :datetime
        add_column :departments, :deleted_at, :datetime
  end

  def self.down
        remove_column :people, :deleted_at
        remove_column :households, :deleted_at
        remove_column :groups, :deleted_at
        remove_column :jobs, :deleted_at
        remove_column :teams, :deleted_at
        remove_column :ministries, :deleted_at
        remove_column :departments, :deleted_at
        remove_column :table_name, :column_name
  end
end
