class NoteTypes < ActiveRecord::Migration
  def self.up
    create_table :note_types do |t|
        t.column :name, :string
        t.column :created_by, :string
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
        t.column :updated_by, :string
    end
    
    add_column :notes, :confidential, :boolean
    
    add_index :notes, :noteable_id
    
  end

  def self.down
  end
end

