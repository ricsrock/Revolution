class AddMeetingToSignUps < ActiveRecord::Migration
  def change
    add_column :sign_ups, :meeting_id, :integer
    add_index :sign_ups, :meeting_id
  end
end