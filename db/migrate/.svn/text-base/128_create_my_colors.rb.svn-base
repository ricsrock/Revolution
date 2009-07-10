class CreateMyColors < ActiveRecord::Migration
  def self.up
    create_table :my_colors do |t|
      t.column :name, :string
      t.column :updated_at, :datetime
      t.column :created_at, :datetime
      t.column :created_by, :string
      t.column :updated_by, :string
    end
  end

  def self.down
  end
end
