class NoteIndexes < ActiveRecord::Migration
  def self.up
    add_index :notes, :noteable_type
    add_index :notes, :type_id
  end

  def self.down
  end
end
