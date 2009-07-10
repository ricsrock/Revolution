class ColorsAdjectivesAnimals < ActiveRecord::Migration
  def self.up
    create_table :colors do |t|
      t.column :name, :string
      t.column :updated_at, :datetime
      t.column :created_at, :datetime
      t.column :created_by, :string
      t.column :updated_by, :string
    end
    
    create_table :animals do |t|
      t.column :name, :string
      t.column :updated_at, :datetime
      t.column :created_at, :datetime
      t.column :created_by, :string
      t.column :updated_by, :string
    end
    
    create_table :adjectives do |t|
      t.column :name, :string
      t.column :updated_at, :datetime
      t.column :created_at, :datetime
      t.column :created_by, :string
      t.column :updated_by, :string
    end
    
  end

  def self.down
    drop_table :colors
    drop_table :animals
    drop_table :adjectives
  end
end
