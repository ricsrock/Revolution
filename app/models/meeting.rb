class Meeting < ActiveRecord::Base
   belongs_to :group, :class_name => "Group", :foreign_key => "group_id"
   belongs_to :instance, :class_name => "Instance", :foreign_key => "instance_id"
   belongs_to :room, :class_name => "Room", :foreign_key => "room_id"
   
   has_many :attendances
   
   validates :instance_id, :group_id, :room_id, :presence => true
      
   def current_attendances
     self.attendances.where(checkout_time: nil)
   end

end
