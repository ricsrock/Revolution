class AddLocationIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :location_id, :integer
    add_index :groups, :location_id
  end
end
