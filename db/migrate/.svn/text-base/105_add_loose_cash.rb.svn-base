class AddLooseCash < ActiveRecord::Migration
  def self.up
        add_column :batches, :loose_cash, :decimal, :precision => 9, :scale => 2
  end

  def self.down
        remove_column :batches, :loose_cash
  end
end
