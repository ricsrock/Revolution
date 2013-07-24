class FixHouseholdsDefaultCreatedAndUpdatedAts < ActiveRecord::Migration
  def change
    change_column :households, :created_at, :datetime, default: nil
    change_column :households, :updated_at, :datetime, default: nil
  end
end