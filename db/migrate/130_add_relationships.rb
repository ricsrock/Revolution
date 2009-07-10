class AddRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.column :relationship_type_id, :integer
      t.column :person_id, :integer
      t.column :relates_to_id, :integer
      t.column :person_role_id, :integer
      t.column :relates_to_role_id, :integer
      t.column :start_date, :datetime
      t.column :end_date, :datetime
      t.column :deactived_on, :datetime
      t.column :web_access, :boolean
      t.column :created_by, :string
      t.column :updated_by, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    
    create_table :relationship_types do |t|
      t.column :name, :string
      t.column :created_at, :datetime
      t.column :created_by, :string
      t.column :updated_at, :datetime
      t.column :updated_by, :string
    end
    
    create_table :relationship_roles do |t|
      t.column :name, :string
      t.column :relationship_type_id, :integer
      t.column :created_by, :string
      t.column :updated_by, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    
  end

  def self.down
    drop_table :relationships
    drop_table :relationship_types
    drop_table :relationship_roles
  end
end
