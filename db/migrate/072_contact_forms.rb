class ContactForms < ActiveRecord::Migration
  def self.up
    create_table :contact_forms do |t|
      t.column :name, :string
      t.column :created_by, :string
      t.column :updated_by, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :contact_forms
  end
end
