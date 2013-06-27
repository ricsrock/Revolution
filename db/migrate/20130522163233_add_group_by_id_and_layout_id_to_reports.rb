class AddGroupByIdAndLayoutIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :group_by_id, :integer
    add_column :reports, :layout_id, :integer
    add_index :reports, :group_by_id
    add_index :reports, :layout_id
  end
end