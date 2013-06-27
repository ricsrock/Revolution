class AddArchivedAtToGroups < ActiveRecord::Migration
  def change
    rename_column :groups, :archived_on, :archived_at
  end
end