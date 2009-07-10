class AddCheckinType < ActiveRecord::Migration
  def self.up
    add_column :attendances, :checkin_type_id, :integer
    remove_column :attendances, :checkin_as_id
  end

  def self.down
  end
end
