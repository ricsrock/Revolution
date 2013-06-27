class CreateGroupBys < ActiveRecord::Migration
  def change
    create_table :group_bys do |t|
      t.integer :record_type_id
      t.string :column_name

      t.timestamps
    end
    add_index :group_bys, :record_type_id
  end
    
end