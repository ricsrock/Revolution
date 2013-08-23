class MeetsOn < ActiveRecord::Base
  belongs_to :group, :class_name => "Group", :foreign_key => "group_id"
  belongs_to :weekday, :class_name => "Weekday", :foreign_key => "weekday_id"
  
  validates :weekday_id, uniqueness: { scope: :group_id, messsage: "Taken" }
  # validates :group_id, :weekday_id, :presence => true
  # validates_presence_of :group, :message => "must have a group"
  # validates_presence_of :weekday, :message => "must have a weekday"
end
