class IndexContributions < ActiveRecord::Migration
  def self.up
    add_index :contributions, :batch_id
    add_index :contributions, :person_id
    add_index :contributions, :deleted_at
    add_index :contributions, :created_at
    
    
    
  end

  def self.down
  end
end
