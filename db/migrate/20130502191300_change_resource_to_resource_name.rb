class ChangeResourceToResourceName < ActiveRecord::Migration
  def change
    rename_column :permissions, :resource, :resource_name
  end
end
