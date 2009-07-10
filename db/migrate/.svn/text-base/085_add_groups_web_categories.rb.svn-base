class AddGroupsWebCategories < ActiveRecord::Migration
  def self.up
    create_table :groups_web_categories, :id => false do |t|
      t.column :group_id, :integer
      t.column :web_category_id, :integer
    end
    
    add_index :groups_web_categories, :group_id
    add_index :groups_web_categories, :web_category_id
    
  end
  


  def self.down
    drop_table :groups_web_categories
  end
end
