class ChangeContacts < ActiveRecord::Migration
  def self.up
        rename_column :contacts, :responsible_department_id, :responsible_ministry_id
        rename_column :contact_types, :default_responsible_department_id, :default_responsible_ministry_id
  end

  def self.down
        rename_column :contacts, :responsible_ministry_id, :responsible_department_id
        rename_column :contact_types, :default_responsible_ministry_id, :default_responsible_department_id
  end
end
