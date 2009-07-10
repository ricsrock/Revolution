class EventType < ActiveRecord::Base
  has_many :events
  has_many :auto_instance_types
  
  has_many :instance_types, :through => :auto_instance_types
end
