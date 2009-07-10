class AddLatLng < ActiveRecord::Migration
  def self.up
        add_column :households, :lat, :float
        add_column :households, :lng, :float
        add_column :households, :address, :string
  end

  def self.down
        remove_column :households, :lat
        remove_column :households, :lng
        remove_column :households, :address
  end
end
