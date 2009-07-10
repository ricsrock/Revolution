class CreateFunds < ActiveRecord::Migration
  def self.up
    create_table :funds do |t|
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :created_by, :string
      t.column :updated_by, :string
      t.column :comments, :text
    end
  end

  def self.down
    drop_table :funds
  end
end
