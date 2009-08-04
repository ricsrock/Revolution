class InitialSupplement < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.column :name, :string
      t.column :address1, :string
      t.column :address2, :string
      t.column :city, :string
      t.column :state, :string
      t.column :zip, :integer
      t.column :created_by, :string
      t.column :updated_by, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    
    add_index :organizations, :id
    
    create_table :associates do |t|
      t.column :organization_id, :integer
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :comments, :text
      t.column :created_by, :string
      t.column :updated_by, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    
    add_index :associates, :id
    add_index :associates, :organization_id
    
    add_column :relationship_types, :auto_notify, :boolean
    add_column :relationship_types, :recipients, :string
    
    add_column :people, :has_a_picture, :boolean
    
    add_column :people, :enrolled, :boolean
    add_column :people, :involved, :boolean
    add_column :people, :connected, :boolean
    
    add_index :people, :connected
    add_index :people, :involved
    add_index :people, :enrolled
    add_index :people, :has_a_picture
    
    add_column :contributions, :contributable_id, :integer
    add_column :contributions, :contributable_type, :string
    
    add_column :organizations, :recent_contr, :datetime
    add_column :organizations, :contr_count, :integer, :default => 0
    add_index :organizations, :contr_count
    add_index :organizations, :recent_contr

  end

  def self.down
  end
end
