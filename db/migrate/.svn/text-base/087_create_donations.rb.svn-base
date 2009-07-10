class CreateDonations < ActiveRecord::Migration
  def self.up
    create_table :donations do |t|
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :created_by, :string
      t.column :updated_by, :string
      t.column :comments, :text
      t.column :contribution_id, :integer
      t.column :amount, :decimal, :precision => 9, :scale => 2 # ?????
      t.column :fund_id, :integer
    end
  end

  def self.down
    drop_table :donations
  end
end
