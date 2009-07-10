class LockBatch < ActiveRecord::Migration
  def self.up
    add_column :batches, :locked, :boolean, :default => false
  end

  def self.down
    remove_column :batches, :locked
  end
end
