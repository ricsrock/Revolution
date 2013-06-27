class AddTagGroupIdToTaggings < ActiveRecord::Migration
  def change
    add_column :taggings, :tag_group_id, :integer
    add_index :taggings, :tag_group_id
  end
end