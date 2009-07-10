class CreateSmartGroups < ActiveRecord::Migration
  def self.up
    create_table :smart_groups do |t|
      t.column :name, :string
      t.column :definition, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :created_by, :string
      t.column :updated_by, :string
    end
  end

  def self.down
    drop_table :smart_groups
  end
end
