class AddCheckinCodeToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :checkin_code, :string
    add_index :groups, :checkin_code
  end
end
