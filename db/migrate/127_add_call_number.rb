class AddCallNumber < ActiveRecord::Migration
  def self.up
    add_column :attendances, :call_number, :string
  end

  def self.down
    remove_column :attendances, :call_number, :string
  end
end
