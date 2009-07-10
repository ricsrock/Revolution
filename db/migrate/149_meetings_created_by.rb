class MeetingsCreatedBy < ActiveRecord::Migration
  def self.up
    add_column :meetings, :created_by, :string
    add_column :meetings, :updated_by, :string
    add_column :meetings, :created_at, :datetime
    add_column :meetings, :updated_at, :datetime
  end

  def self.down
    remove_column :meetings, :created_by
  end
end
