class AddOrgLatAndLng < ActiveRecord::Migration
  def self.up
    add_column :organizations, :lat, :decimal, :precision => 15, :scale => 10
    add_column :organizations, :lng, :decimal, :precision => 15, :scale => 10
  end

  def self.down
  end
end
