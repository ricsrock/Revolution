class IndexDonations < ActiveRecord::Migration
  def self.up
    add_index :donations, :contribution_id
    add_index :donations, :fund_id
    add_index :donations, :created_at
  end

  def self.down
  end
end
