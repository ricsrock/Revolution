class IndexContacts < ActiveRecord::Migration
  def self.up
    add_index :contacts, :created_by
    add_index :contacts, :stamp
    add_index :contacts, :responsible_user_id
    add_index :contacts, :created_at
    add_index :contacts, :person_id
    add_index :contacts, :household_id
    add_index :contacts, :contact_type_id
    add_index :contacts, :closed_at
    add_index :contacts, :reopen_at
    add_index :contacts, :deleted_at
    
    add_index :people, :deleted_at
    add_index :households, :deleted_at
  end

  def self.down
  end
end
