class AddEmailComments < ActiveRecord::Migration
  def self.up
    add_column :emails, :comments, :string
    add_column :emails, :primary, :boolean
    add_column :emails, :comm_type, :integer
    add_column :phones, :comments, :string
    add_column :phones, :primary, :boolean
    add_column :phones, :comm_type, :integer
  end

  def self.down
    remove_column :emails, :comments
    remove_column :emails, :primary
    remove_column :emails, :email_type
    remove_column :phones, :comments
    remove_column :phones, :primary
    remove_column :phones, :phone_type
  end
end
