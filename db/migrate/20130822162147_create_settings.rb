class CreateSettings < ActiveRecord::Migration
  def change
    drop_table :settings
    create_table :settings do |t|
      t.string :key
      t.text :value

      t.timestamps
    end
    add_index :settings, [:key], :unique => true, :name => 'key_udx'
  end
end
