class CreateInquiries < ActiveRecord::Migration
  def change
    create_table :inquiries do |t|
      t.integer :person_id
      t.integer :group_id
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
    add_index :inquiries, :person_id
    add_index :inquiries, :group_id
  end
end