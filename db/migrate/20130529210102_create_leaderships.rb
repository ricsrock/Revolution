class CreateLeaderships < ActiveRecord::Migration
  def change
    create_table :leaderships do |t|
      t.integer :leadable_id
      t.string :leadable_type
      t.string :type
      t.integer :person_id
      t.string :title

      t.timestamps
    end
    add_index :leaderships, :leadable_id
    add_index :leaderships, :leadable_type
    add_index :leaderships, :person_id
    add_index :leaderships, :type
  end
end