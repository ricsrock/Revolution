class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :name
      t.integer :record_type_id
      t.string :group_by
      t.text :parameters
      t.string :layout
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
    add_index :reports, :record_type_id
  end
end