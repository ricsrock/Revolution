class AddCadenceIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :cadence_id, :integer
    add_index :groups, :cadence_id
  end
end