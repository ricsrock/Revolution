class AddEmailPoly < ActiveRecord::Migration
  def self.up
    add_column :emails, :emailable_id, :integer
    add_column :emails, :emailable_type, :string
  end

  def self.down
    remove_column :emails, :emailable_id
    remove_column :emails, :emailable_type
  end
end
