class ChangeSchedulings < ActiveRecord::Migration
  def self.up
    rename_table :schedulings, :assignments
  end

  def self.down
    rename_table :assignments
  end
end
