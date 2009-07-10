class AddWorshipAttends < ActiveRecord::Migration
  def self.up
        add_column :people, :worship_attends, :integer
  end

  def self.down
        remove_column :people, :worship_attends
  end
end
