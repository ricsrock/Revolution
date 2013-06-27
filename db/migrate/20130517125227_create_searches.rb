class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :klass
      t.text :parameters
      t.text :created_by
      t.text :updated_by
      t.timestamps
    end
    add_index :searches, :klass
  end
end