class AddNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.column :type_id, :integer
      t.column :text, :text
      t.column :created_by, :string
      t.column :updated_by, :string
      t.column :updated_at, :datetime
      t.column :noteable_id, :integer
      t.column :noteable_type, :string
    end
  end

  def self.down
    drop_table :notes
  end
end
