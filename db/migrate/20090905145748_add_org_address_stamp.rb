class AddOrgAddressStamp < ActiveRecord::Migration
  def self.up
    add_column :organizations, :address, :string
  end

  def self.down
  end
end
