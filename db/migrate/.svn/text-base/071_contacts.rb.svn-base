class Contacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.column :contact_type_id, :integer
      t.column :responsible_user_id, :integer
      t.column :responsible_department_id, :integer
      t.column :person_id, :integer
      t.column :household_id, :integer
      t.column :start_date, :datetime
      t.column :end_date, :datetime
      t.column :comments, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :created_by, :string
      t.column :updated_by, :string
      t.column :open, :boolean, :default => true
    end
  end

  def self.down
    drop_table :contacts
  end
end
