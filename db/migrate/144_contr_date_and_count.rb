class ContrDateAndCount < ActiveRecord::Migration
  def self.up
    add_column :people, :recent_contr, :datetime
    add_column :people, :contr_count, :integer, :default => 0
    add_index :people, :contr_count
    add_index :people, :recent_contr
  end

  def self.down
  end
end
