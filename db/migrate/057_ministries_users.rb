class MinistriesUsers < ActiveRecord::Migration
  def self.up
    create_table :ministries_users, :id => false do |t|
      t.column :ministry_id, :integer
      t.column :user_id, :integer
    end
    
    add_index :ministries_users, :ministry_id
    add_index :ministries_users, :user_id
    
  end
  


  def self.down
    drop_table :ministries_users
  end
end
