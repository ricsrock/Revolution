class AddMaxDate < ActiveRecord::Migration
  def self.up
    add_column :people, :max_date, :date
  end

  def self.down
    remove_column :people, :max_date
  end
end
