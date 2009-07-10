class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.column :name, :string
      t.column :created_at, :datetime, :default => Time.now
      t.column :updated_at, :datetime, :default => Time.now
      t.column :created_by, :string
      t.column :updated_by, :string 
      t.column :tag_group_id, :integer
    end
  end

  def self.down
    drop_table :tags
  end
end
