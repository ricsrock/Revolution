class AddTaggingsIndexes < ActiveRecord::Migration
  def self.up
    add_index :taggings, :person_id
    add_index :taggings, :tag_id
  end

  def self.down
  end
end
