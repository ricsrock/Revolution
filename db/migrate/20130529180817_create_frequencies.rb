class CreateFrequencies < ActiveRecord::Migration
  def change
    create_table :frequencies do |t|
      t.integer :group_id
      t.integer :cadence_id

      t.timestamps
    end
    add_index :frequencies, :group_id
    add_index :frequencies, :cadence_id
  end
end