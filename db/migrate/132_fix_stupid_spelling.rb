class FixStupidSpelling < ActiveRecord::Migration
  def self.up
    rename_column :relationships, :deactived_on, :deactivated_on
  end

  def self.down
    rename_column :relationships, :deactivated_on, :deactived_on
  end
end
