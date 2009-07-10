class AddFundName < ActiveRecord::Migration
  def self.up
    add_column :funds, :name, :string
  end

  def self.down
  end
end
