class AddReopenAt < ActiveRecord::Migration
  def self.up
        add_column :contacts, :reopen_at, :datetime
  end

  def self.down
        remove_column :contacts, :reopen_at
  end
end
