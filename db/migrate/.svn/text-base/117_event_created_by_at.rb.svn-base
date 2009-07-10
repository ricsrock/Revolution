class EventCreatedByAt < ActiveRecord::Migration
  def self.up
        add_column :events, :created_by, :string
        add_column :events, :updated_by, :string
        add_column :events, :created_at, :datetime
        add_column :events, :updated_at, :datetime
  end

  def self.down
        remove_column :events, :created_by
        remove_column :events, :updated_by
        remove_column :events, :created_at
        remove_column :events, :updated_at
  end
end
