class EventType < ActiveRecord::Base
  has_many :auto_instance_types, :dependent => :destroy # destroy all auto_instance_types when event_type is destroyed
  has_many :instance_types, :through => :auto_instance_types
  
  
  def available_instance_types
    InstanceType.all(:conditions => ['instance_types.id NOT IN
                                  (SELECT auto_instance_types.instance_type_id FROM auto_instance_types
                                  WHERE (auto_instance_types.event_type_id = ?))', self.id], :order => :name)
  end
  
end
