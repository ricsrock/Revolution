class EmailsAndPhones < ActiveRecord::Migration
  def self.up
    add_index :emails, :email
    add_index :emails, [:emailable_id, :emailable_type], :name => 'emailable_index'
    add_index :phones, :number
    add_index :phones, [:phonable_id, :phonable_type], :name => 'phonable_index'
  end

  def self.down
  end
end
