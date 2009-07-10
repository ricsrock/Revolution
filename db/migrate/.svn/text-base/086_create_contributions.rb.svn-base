class CreateContributions < ActiveRecord::Migration
  def self.up
    create_table :contributions do |t|
      t.column :total, :decimal, :precision => 9, :scale => 2 #??? for entering the total amount of the contribution; for reconciling split entry
      t.column :batch_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :created_by, :string
      t.column :updated_by, :string
      t.column :comments, :text
      t.column :check_num, :integer
      t.column :date, :datetime # for check date... if diff from batch date?
      t.column :person_id, :integer
    end
  end

  def self.down
    drop_table :contributions
  end
end
