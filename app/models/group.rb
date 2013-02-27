class Group < ActiveRecord::Base
  acts_as_nested_set
  
  belongs_to :default_room, :class_name => "Room", :foreign_key => "default_room_id"
  
  has_many :meetings
end
