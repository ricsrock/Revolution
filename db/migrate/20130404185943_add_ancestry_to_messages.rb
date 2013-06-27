class AddAncestryToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :ancestry, :string
    add_index :messages, :ancestry
    
    change_column :messages, :from, :string
    add_column  :messages, :user_id, :integer
    add_index :messages, :user_id
    
    remove_column :messages, :recipients
  end
end