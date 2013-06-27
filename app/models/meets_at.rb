class MeetsAt < ActiveRecord::Base
  belongs_to :group, :class_name => "Group", :foreign_key => "group_id"
  belongs_to :meeting_time, :class_name => "MeetingTime", :foreign_key => "meeting_time_id"
  
  validates :meeting_time_id, :uniqueness => { scope: :group_id }
  validates :group_id, :meeting_time_id, :presence => true
end
