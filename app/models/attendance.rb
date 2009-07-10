class Attendance < ActiveRecord::Base
  belongs_to :meeting
  belongs_to :person
  belongs_to :checkin_type
  
# This needs to be "turned on" once the app is in production.
# It checks for uniqueness against all attendence records, even "checked out" ones.  
  validates_uniqueness_of :meeting_id, :scope => [:person_id], :message => 'already checked in'
  
  after_destroy { |record| record.person.set_recent_attend
                           record.person.set_first_attend
                           record.person.set_attend_count
                           record.person.set_second_attend
                           record.person.set_attendance_status
                           record.person.set_worship_attends if record.meeting.group.name == 'Adult Worship'
                           record.person.set_max_worship_date if record.meeting.group.name == 'Adult Worship'
                           record.person.household.set_attendance_status if record.person.household
                           #AttendanceTracker.do_new_attendance(record)
                           record.person.do_attendance_tracker(record.meeting.id) 
                           }
                           
  after_create  { |record| record.person.set_recent_attend
                           record.person.set_first_attend
                           record.person.set_attend_count
                           record.person.set_second_attend
                           record.person.set_attendance_status
                           record.person.set_worship_attends if record.meeting.group.name == 'Adult Worship'
                           record.person.set_max_worship_date if record.meeting.group.name == 'Adult Worship'
                           record.person.household.set_attendance_status if record.person.household
                           record.person.enroll_in_group(record.meeting.group.id) 
                           record.person.check_for_guest_flow_contacts
                           AttendanceTracker.do_new_attendance(record)
                           }
                           
  #after_save { |record| AttendanceTracker.do_new_attendance(record)}
  
  def self.active_by_person(person_id)
    find(:all, :conditions => {:checkout_time => nil, :person_id => person_id})
  end
  
  def self.all_active
    find(:all, :conditions => {:checkout_time => nil}, :include => [:meeting, :person]) 
  end
  
  def checkout
      update_attributes(:checkout_time => Time.now)
  end
  
  def self.active_by_person_and_instance(person_id, instance_id)
    find(:all, :conditions => ['person_id LIKE ? AND meetings.instance_id LIKE ?', person_id, instance_id],
               :include => [:meeting])
  end
  
  def smart_checkout_time
    if self.checkout_time.nil?
      "No Checkout Time"
    else
      self.checkout_time.strftime('%I:%M')
    end
  end
  
  def date
    self.meeting.instance.event.date
  end
  
  def group_and_instance
    self.meeting.group.name + ' ' + self.meeting.instance.instance_type.name
    rescue nil
  end
  
  def self.do_security_phrase
    @adjectives = Adjective.find(:all).collect {|a| a.name}
    @animals = Animal.find(:all).collect {|b| b.name}
    @colors = MyColor.find(:all).collect {|c| c.name}
    phrase = ""
    phrase << @adjectives[rand(@adjectives.length-1)]
    phrase << " "
    phrase << @colors[rand(@colors.length-1)]
    phrase << " "
    phrase << @animals[rand(@animals.length-1)]
    phrase
  end
  
  def self.unique_security_phrase(meeting_id)
    try = Attendance.do_security_phrase
    meeting = Meeting.find(meeting_id)
    event = Event.find(meeting.instance.event.id)
    @phrases = event.attendances.collect {|a| a.security_code}
    @phrases.include?(try) ? Attendance.unique_security_phrase(meeting_id) : try
  end
  
  def self.do_call_number
    numbers = ("1".."9").to_a
    number = ""
    3.times {|i| number << numbers[rand(numbers.length-1)]}
    number
  end
  
  def self.unique_call_number(meeting_id)
    number = Attendance.do_call_number
    meeting = Meeting.find(meeting_id)
    event = Event.find(meeting.instance.event.id)
    @numbers = event.attendances.collect {|a| a.call_number}
    @numbers.include?(number) ? Attendance.unique_call_number(meeting_id) : number
  end
  
  def self.find_all_by_person_and_group(person_id,group_id)
    Attendance.find(:all,
                    :include => :meeting,
                    :conditions => ['attendances.person_id = ? AND meetings.group_id = ?',person_id,group_id])
  end
  

    
  
end
