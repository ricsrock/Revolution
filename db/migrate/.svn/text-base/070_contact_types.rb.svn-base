class ContactTypes < ActiveRecord::Migration
  def self.up
    create_table :contact_types do |t|
      t.column :name, :string
      t.column :default_responsible_user_id, :integer
      t.column :default_responsible_department_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :created_by, :string
      t.column :updated_by, :string
    end
  end

  def self.down
    drop_table :contact_types
  end
end
