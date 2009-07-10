class CreateTagGroups < ActiveRecord::Migration
  def self.up
    create_table :tag_groups do |t|
      t.column :name, :string
      t.column :created_at, :datetime, :default => Time.now
      t.column :updated_at, :datetime, :default => Time.now
      t.column :created_by, :string
      t.column :updated_by, :string
    end
  end

  def self.down
    drop_table :tag_groups
  end
end
