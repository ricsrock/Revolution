class AddSecurityCode < ActiveRecord::Migration
  def self.up
    add_column :attendances, :security_code, :string
  end

  def self.down
    remove_column :attendances, :security_code
  end
end
