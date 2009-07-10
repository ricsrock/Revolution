class AddNumMarked < ActiveRecord::Migration
  def self.up
    add_column :meetings, :num_marked, :integer
  end

  def self.down
  end
end
