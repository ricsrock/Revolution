class Meeting < ActiveRecord::Base
  belongs_to :instance
  belongs_to :group
  belongs_to :room
  has_many :attendances, :dependent => :destroy
  has_many :active_attendances, :class_name => "Attendance",
                                :conditions => {:checkout_time => nil}
  has_many :active_staff_attendances, :class_name => "Attendance",
                                      :conditions => {:checkout_time => nil, :checkin_type_id => 2}
  has_many :staff_attendances, :class_name => "Attendance",
                                      :conditions => {:checkin_type_id => 2}
  has_many :participant_attendances, :class_name => "Attendance",
            :conditions => {:checkin_type_id => 1}
  has_many :assignments, :dependent => :destroy
  has_many :complete_attendances, :class_name => "Attendance",
                                  :conditions => ['checkout_time IS NOT NULL']

  acts_as_paranoid
  
  validates_uniqueness_of :group_id, :scope => :instance_id, :message => 'Only one meeting per group for each instance is allowed.' #only one meeting for a given group per instance
  validates_presence_of :room_id, :group_id, :instance_id
  
  before_validation_on_update {|record|
                                record.zero_nils}
  after_update {|record|
                record.instance.set_total}
  before_save {|record| record.set_num_marked}
  
  
  def zero_nils
    if self.leaders_count.nil?
        self.leaders_count = 0
    end
    if self.participants_count.nil?
        self.participants_count = 0
    end
  end
  
  def set_num_marked
    self.num_marked = self.attendances.size
  end
  
  def set_total
    self.update_attribute(:total_count, (self.leaders_count + self.participants_count))
  end
  
  def self.find_by_selected_instance(instance_id)
    find(:all,
		    :select => 'meetings.id, groups.name as name, instance_id',
    		:joins => 'JOIN groups on groups.id = meetings.group_id',
    		:conditions => ['instance_id = ?', instance_id],
    		:order => ['name Asc'])
  end
  
  def self.find_by_selected_instance_include(instance_id)
    find(:all,
		    :select => 'meetings.id, groups.name as name, instance_id',
		    :include => [:room, :group],
    		#:joins => 'JOIN groups on groups.id = meetings.group_id',
    		:conditions => ['instance_id = ?', instance_id])
  end
  
  def self.find_by_assignment_form(instance_type_id, group_id, start_date, weeks_on)
    find(:all, :select => ['meetings.id'],
               :conditions => ['instance_type_id = ? AND group_id = ? AND date >= ?', instance_type_id, group_id, start_date],
               :joins => ['JOIN instances ON instances.id = meetings.instance_id
                            JOIN instance_types ON instance_types.id = instances.instance_type_id
                            JOIN groups ON groups.id = meetings.group_id
                            JOIN events ON events.id = instances.event_id'],
               :limit => [weeks_on],
               :order => ['date ASC'])
  end
  
  def self.find_by_instance_id(instance_id)
    find(:all, :conditions => ['instance_id LIKE ?', instance_id], :order => ['instance_id, group_id Asc'])
  end
  
  def self.find_by_instance_ids(instance_ids)
        find(:all, :conditions => ['instance_id IN (?)', instance_ids])
  end
  
  def self.find_by_event_instance_name_group_name(event_id, instance_name, group_name)
    find(:first, :select => ['meetings.id, instance_types.name as instance_name, instances.event_id, groups.name as group_name'], 
                 :conditions => ['instances.event_id LIKE ? AND instance_types.name LIKE ? AND groups.name LIKE ?',
                                event_id, instance_name, group_name],
                :joins => ['JOIN instances ON instances.id = meetings.instance_id
                            JOIN instance_types ON instance_types.id = instances.instance_type_id
                            JOIN groups ON groups.id = meetings.group_id'])
  end
  
  def self.find_by_instance_and_group(instance_id, group_id)
    find(:first, :conditions => ['meetings.instance_id LIKE ? AND meetings.group_id LIKE ?',instance_id, group_id])
  end
  
  def checkedin_count
    self.active_attendances.count
  end
  
  def staff_checkedin_count
    self.active_staff_attendances.count
  end
  
  def participant_checkedin_count
    (self.checkedin_count - self.staff_checkedin_count)
  end
  
  def self.find_default(group_id, instance_id)
    group_id = person.default_group_id
    instance_id = Setting.one.curr_instance
    find(:first, :conditions => {:group_id => group_id, :instance_id => instance_id})
  end
  
  def date
    self.instance.event.formatted_date
  end
  
  def date_sort
     self.instance.event.date
  end
  
  def date_name
    self.date + ' ' + self.name
  end
  
  # This is EXTREMELY cheesy...
  def self.find_by_event_id_and_group_name(event_id,group_name)
    find(:first, :select => ['meetings.id'], :joins => ['LEFT OUTER JOIN groups ON meetings.group_id = groups.id
                            INNER JOIN instances ON meetings.instance_id = instances.id
                            INNER JOIN events ON instances.event_id = events.id'],
                 :conditions => ['(instances.event_id = ?) AND (groups.name LIKE ?)',event_id,group_name])
  end
  
  def people_in_attendance
    Person.find(:all, :select => ['people.id,meetings.id as meeting_id,attendances.id as attendance_id'],
                      :joins => ['LEFT OUTER JOIN attendances ON people.id = attendances.person_id
                                  LEFT OUTER JOIN meetings ON attendances.meeting_id = meetings.id'],
                      :conditions => ['attendances.meeting_id = ?', self.id])
  end
  

    
end
