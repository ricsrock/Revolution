class Meeting < ActiveRecord::Base
   belongs_to :group, :class_name => "Group", :foreign_key => "group_id"
   belongs_to :instance, :class_name => "Instance", :foreign_key => "instance_id"
   belongs_to :room, :class_name => "Room", :foreign_key => "room_id"
   
   has_many :attendances
   
   validates :instance_id, :group_id, :room_id, :presence => true
  
   acts_as_stampable
   
   def current_attendances
     self.attendances.where(checkout_time: nil)
   end
   
   def checked_out_attendances
     self.attendances.checked_out
   end
   
   def update_num_marked
     self.update_attribute(:num_marked, self.checked_out_attendances.size)
   end
   
   def date
     instance.try(:event).try(:date)
   end
   
   # Used for text checkin. Can only text-checkin to a meeting within a 2-day date window. 
   def current?
     self.date && (self.date >= Time.zone.now.to_date - 1.day) && (self.date <= Time.zone.now.to_date + 1.day)
   end

end
