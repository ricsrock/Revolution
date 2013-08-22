class AddRallyNightNumberToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :inquiry_number, :integer
  end
end
