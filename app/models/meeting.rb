class Meeting < ActiveRecord::Base
   belongs_to :group, :class_name => "Group", :foreign_key => "group_id"
   belongs_to :instance, :class_name => "Instance", :foreign_key => "instance_id"
   belongs_to :room, :class_name => "Room", :foreign_key => "room_id"
   
   has_many :attendances
   
   validates :instance_id, :group_id, :room_id, :presence => true
   validates :checkin_code, :uniqueness => true
  
   acts_as_stampable
   
   def self.do_checkin_code
     numbers = ("1".."9").to_a
     letters = ("a".."z").to_a
     code = ""
     3.times { code << letters.sample }
     3.times { code << numbers.sample }
     code
   end
   
   def set_checkin_code
     self.checkin_code = Meeting.do_checkin_code
     until Meeting.find_by_this_checkin_code(checkin_code).nil?
       self.checkin_code = Meeting.do_checkin_code
       logger.info "======== do checkin code ==========="
     end
   end

   def self.find_by_this_checkin_code(code)
     Meeting.where(checkin_code: code).first
   end
   
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
     self.date && (self.date >= Time.zone.now.to_date - 1.day) && (self.date <= Time.zone.now.to_date + 1.day) && self.checkin_code.present?
   end
   
   def status
     self.current? ? 'Open' : 'Closed'
   end

end
