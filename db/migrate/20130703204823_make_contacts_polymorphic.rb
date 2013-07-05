class MakeContactsPolymorphic < ActiveRecord::Migration
  def change
    add_column :contacts, :contactable_id, :integer
    add_column :contacts, :contactable_type, :string
    add_index :contacts, :contactable_id
    add_index :contacts, :contactable_type
  end
end