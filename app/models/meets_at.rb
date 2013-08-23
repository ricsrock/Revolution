class MeetsAt < ActiveRecord::Base
  belongs_to :group, :class_name => "Group", :foreign_key => "group_id"
  belongs_to :meeting_time, :class_name => "MeetingTime", :foreign_key => "meeting_time_id"
  
  validates :meeting_time_id, :uniqueness => { scope: :group_id }
  # validates :group_id, :meeting_time_id, :presence => true
  # validates_presence_of :group, :on => :create, :message => "can't be blank"
  # validates_presence_of :meeting_time, :on => :create, :message => "can't be blank"
end
