class AddTypeToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :type, :string
    add_index :groups, :type
  end
end
