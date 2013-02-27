class Attendance < ActiveRecord::Base
  belongs_to :person, :class_name => "Person", :foreign_key => "person_id"
  belongs_to :meeting, :class_name => "Meeting", :foreign_key => "meeting_id"
  
  validates_presence_of :person_id, :meeting_id, :on => :create, :message => "can't be blank"
  validates_uniqueness_of :person_id, :scope => :meeting_id, :on => :create, :message => "is already checked into this meeting"
  
  
  def checkout
    self.update_attribute(:checkout_time, Time.now)
  end
end
