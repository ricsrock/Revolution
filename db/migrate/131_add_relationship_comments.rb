class AddRelationshipComments < ActiveRecord::Migration
  def self.up
    add_column :relationships, :comments, :text
  end

  def self.down
  end
end
