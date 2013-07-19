class AddCheckinCodeToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :checkin_code, :string
    add_index :meetings, :checkin_code
  end
end