class RemoveGroupByColumnFromReports < ActiveRecord::Migration
  def change
    remove_column :reports, :group_by
  end
end
