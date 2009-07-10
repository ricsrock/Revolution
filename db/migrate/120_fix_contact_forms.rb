class FixContactForms < ActiveRecord::Migration
  def self.up
      remove_column :contact_forms_contact_types, :id
      
      add_index :contact_forms_contact_types, :contact_form_id
      add_index :contact_forms_contact_types, :contact_type_id
  end

  def self.down
  end
end
