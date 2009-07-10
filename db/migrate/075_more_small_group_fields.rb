class MoreSmallGroupFields < ActiveRecord::Migration
  def self.up
    add_column :groups, :meets_at_household_id, :integer
    add_column :groups, :leader_name_for_printing_id, :integer
    add_column :groups, :blurb, :text
    add_column :groups, :meets_on, :string
    add_column :groups, :time_from, :time
    add_column :groups, :time_until, :time
  end

  def self.down
    remove_column :groups, :meets_at_household_id
    remove_column :groups, :leader_name_for_printing_id
    remove_column :groups, :blurb
    remove_column :groups, :meets_on
    remove_column :groups, :time_from
    remove_column :groups, :time_until
  end
end
