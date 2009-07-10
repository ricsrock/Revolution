class ContactFormsContactTypes < ActiveRecord::Migration
  def self.up
    create_table :contact_forms_contact_types do |t|
      t.column :contact_form_id, :integer
      t.column :contact_type_id, :integer
    end
  end

  def self.down
    drop_table :contact_forms_contact_types
  end
end
