class Instance < ActiveRecord::Base
  belongs_to :event
  belongs_to :instance_type
  has_many :meetings, :dependent => :destroy
  has_many :active_attendances, :through => :meetings, :conditions => "checkout_time IS NULL"
  has_many :attendances, :through => :meetings
  has_many :staff_attendances, :through => :meetings, :conditions => {:checkin_type_id => 2 }
  has_many :participant_attendances, :through => :meetings, :conditions => {:checkin_type_id => 1 }

  acts_as_paranoid
  
#  validates_presence_of :event_id, :instance_type_id # why on earth did I comment this out?
  
  after_create :auto_create_meetings
  
  def auto_create_meetings
    self.instance_type.auto_groups.each do |autogroup|
      @meeting = Meeting.new(:instance_id => self.id,
                             :group_id => autogroup.group.id,
                             :room_id => autogroup.group.default_room_id)
      @meeting.save
    end
  end
  
  def display_name
    self.instance_type.name  
  end
  
  def set_total
    total = self.meetings.collect {|m| m.total_count}.sum
    self.update_attribute(:total_count, total)
  end
  
  def self.find_by_event_id(event_id)
    find(:all, :conditions => ['event_id LIKE ?', event_id])
  end
  
  def self.find_by_event_ids(event_ids)
      find(:all, :conditions => ['event_id IN (?)', event_ids])
  end
  
  def self.find_current
    @id = Setting.one.current_instance
    find(:first, :conditions => ['id = ?', @id])
  end
  
end
