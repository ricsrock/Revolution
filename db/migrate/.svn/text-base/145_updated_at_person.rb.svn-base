class UpdatedAtPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :updated_at, :datetime
    add_column :people, :created_at, :datetime
  end

  def self.down
    remove_column :people, :updated_at
  end
end
