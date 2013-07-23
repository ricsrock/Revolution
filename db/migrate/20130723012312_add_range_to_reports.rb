class AddRangeToReports < ActiveRecord::Migration
  def change
    add_column :reports, :range, :string
  end
end
