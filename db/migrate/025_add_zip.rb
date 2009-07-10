class AddZip < ActiveRecord::Migration
  def self.up
    add_column :households, :zip, :integer
  end

  def self.down
    remove_column :households, :zip
  end
end
