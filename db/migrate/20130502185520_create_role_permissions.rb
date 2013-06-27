class CreateRolePermissions < ActiveRecord::Migration
  def change
    create_table :role_permissions do |t|
      t.integer :role_id
      t.integer :permission_id

      t.timestamps
    end
    add_index :role_permissions, :role_id
    add_index :role_permissions, :permission_id
  end
end