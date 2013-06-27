class CreateMeetingTimes < ActiveRecord::Migration
  def change
    create_table :meeting_times do |t|
      t.time :time
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
