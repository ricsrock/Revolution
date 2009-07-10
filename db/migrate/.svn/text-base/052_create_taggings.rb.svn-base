class CreateTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      t.column :comments, :string
      t.column :created_at, :datetime, :default => Time.now
      t.column :updated_at, :datetime, :default => Time.now
      t.column :created_by, :string
      t.column :updated_by, :string
      t.column :person_id, :integer
      t.column :tag_id, :integer
      t.column :start_date, :datetime
      t.column :end_date, :datetime
    end
  end

  def self.down
    drop_table :taggings
  end
end
