class Frequency < ActiveRecord::Base
  belongs_to :group, :class_name => "Group", :foreign_key => "group_id"
  belongs_to :cadence, :class_name => "Cadence", :foreign_key => "cadence_id"
  
  validates :group_id, :cadence_id, :presence => true
  validates :cadence_id, :uniqueness => { scope: :group_id }
end
