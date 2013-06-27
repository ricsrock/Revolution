class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :resource
      t.string :action
      t.string :description
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
