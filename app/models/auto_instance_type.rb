class AutoInstanceType < ActiveRecord::Base
  belongs_to :event_type, :class_name => "EventType", :foreign_key => "event_type_id"
  belongs_to :instance_type, :class_name => "InstanceType", :foreign_key => "instance_type_id"
  
  validates :event_type_id, :instance_type_id, :presence => true
end
