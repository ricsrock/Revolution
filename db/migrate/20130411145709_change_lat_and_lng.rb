class ChangeLatAndLng < ActiveRecord::Migration
  def change
    rename_column :households, :lat, :latitude
    rename_column :households, :lng, :longitude
  end
end
