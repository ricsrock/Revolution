class CreateBatches < ActiveRecord::Migration
  def self.up
    create_table :batches do |t|
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :created_by, :string
      t.column :updated_by, :string
      t.column :comments, :text
      t.column :date_collected, :datetime
      t.column :count_total, :decimal, :precision => 9, :scale => 2 # ????
      t.column :contributions_num, :integer # the number of contributions in this batch; for reconciling data-entry
    end
  end

  def self.down
    drop_table :batches
  end
end
