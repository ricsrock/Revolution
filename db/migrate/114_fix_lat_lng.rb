class FixLatLng < ActiveRecord::Migration
  def self.up
      remove_column :households, :lat
      remove_column :households, :lng
      
        add_column :households, :lat, :decimal, :precision => 15, :scale => 10
        add_column :households, :lng, :decimal, :precision => 15, :scale => 10
  end

  def self.down

  end
end
