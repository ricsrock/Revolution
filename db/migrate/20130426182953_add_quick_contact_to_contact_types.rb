class AddQuickContactToContactTypes < ActiveRecord::Migration
  def change
    add_column :contact_types, :quick_contact, :boolean
    add_index :contact_types, :quick_contact
  end
end