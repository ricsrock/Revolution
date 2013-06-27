class CreatePropertyOperators < ActiveRecord::Migration
  def change
    create_table :property_operators do |t|
      t.integer :smart_group_property_id
      t.integer :operator_id

      t.timestamps
    end
    
    add_index :property_operators, :smart_group_property_id
    add_index :property_operators, :operator_id
  end
end