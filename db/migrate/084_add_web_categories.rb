class AddWebCategories < ActiveRecord::Migration
  def self.up
    create_table :web_categories do |t|
      t.column :name, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :created_by, :string
      t.column :updated_by, :string
    end
  end

  def self.down
    drop_table :web_categories
  end
end
