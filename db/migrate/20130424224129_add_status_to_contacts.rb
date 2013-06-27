class AddStatusToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :status, :string
    add_index :contacts, :status
  end
end