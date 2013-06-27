class ChangeTimeToDatetime < ActiveRecord::Migration
  def change
    MeetingTime.destroy_all
    change_column :meeting_times, :time, :datetime
  end
end