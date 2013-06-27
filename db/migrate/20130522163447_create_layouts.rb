class CreateLayouts < ActiveRecord::Migration
  def change
    create_table :layouts do |t|
      t.integer :record_type_id
      t.string :name

      t.timestamps
    end
    add_index :layouts, :record_type_id
  end
end