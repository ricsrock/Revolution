class AddMessagesDepth < ActiveRecord::Migration
  def change
    add_column :messages, :ancestry_depth, :integer, :default => 0
  end
end
