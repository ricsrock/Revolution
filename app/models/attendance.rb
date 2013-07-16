class Attendance < ActiveRecord::Base
  belongs_to :person, :class_name => "Person", :foreign_key => "person_id"
  belongs_to :meeting, :class_name => "Meeting", :foreign_key => "meeting_id"
  
  validates_presence_of :person_id, :meeting_id, :on => :create, :message => "can't be blank"
  validates_uniqueness_of :person_id, :scope => :meeting_id, :on => :create, :message => "is already checked into this meeting"
  validates :call_number, :security_code, :presence => true
  validate :call_number_must_be_unique_for_event
  validate :security_code_must_be_unique_for_event
  
  
  before_validation :set_call_number, :set_security_code, on: :create
  
  after_create {
    |record|
      record.person.set_first_attend
      record.person.set_recent_attend
      record.person.set_max_worship_date if record.meeting.group.name == 'Adult Worship'
      record.person.set_worship_attends if record.meeting.group.name == 'Adult Worship'
      record.person.set_attend_count
      record.person.set_attendance_status
      record.person.set_second_attend
      record.person.enroll_in_group_id(record.meeting.group.id)
      AttendanceTracker.update_for_attendance(record.person_id, record.meeting.group_id)
  }
  
  after_destroy {
    |record|
      record.person.update_first_attend
      record.person.set_recent_attend
      record.person.set_max_worship_date if record.meeting.group.name == 'Adult Worship'
      record.person.set_worship_attends if record.meeting.group.name == 'Adult Worship'
      record.person.set_attend_count
      record.person.set_attendance_status
      record.person.set_second_attend
      record.person.update_enrollment_for_group_id(record.meeting.group.id) # remove from group if no attendances
      AttendanceTracker.update_for_attendance(record.person_id, record.meeting.group_id)
      record.meeting.update_num_marked
  }
  
  after_save {
    |record|
      record.meeting.update_num_marked
  }
  
  def self.un_checked_out
    where(checkout_time: nil)
  end
  
  def self.checked_out
    where(Attendance.arel_table[:checkout_time].not_eq(nil))
  end
  
  def checkout
    self.update_attribute(:checkout_time, Time.now)
  end
  
  def date
    meeting.instance.event.date
  end
  
  def event
    meeting.instance.event
  end
  
  def instance
    meeting.instance
  end
  
  def group
    meeting.group
  end
  
  def set_call_number
    self.call_number = Attendance.do_call_number
    until Attendance.find_by_call_number_this_event(call_number, self).nil?
      self.call_number = Attendance.do_call_number
      logger.info "******** do call number **********"
    end
  end
  
  def set_security_code
    self.security_code = Attendance.do_security_code
    until Attendance.find_by_code_this_event(security_code, self).nil?
      self.security_code = Attendance.do_security_code
      logger.info "======== do attendance code ==========="
    end
  end
  
  def self.find_by_code_this_event(code, attendance)
    event = attendance.meeting.instance.event
    event.attendances.where(security_code: code).first
  end
  
  def self.find_by_call_number_this_event(code, attendance)
    event = attendance.meeting.instance.event
    event.attendances.where(security_code: code).first
  end
  
  
  def self.do_security_code
    @adjectives = Adjective.all.collect {|a| a.name}
    @animals = Animal.all.collect {|b| b.name}
    @colors = MyColor.all.collect {|c| c.name}
    phrase = ""
    phrase << @adjectives.sample
    phrase << " "
    phrase << @colors.sample
    phrase << " "
    phrase << @animals.sample
    phrase
  end
  
  # def self.unique_security_code(meeting_id)
  #   try = Attendance.do_security_phrase
  #   meeting = Meeting.find(meeting_id)
  #   event = Event.find(meeting.instance.event.id)
  #   @codes = event.attendances.collect {|a| a.security_code}
  #   @codes.include?(try) ? Attendance.unique_security_phrase(meeting_id) : try
  # end
  
  def self.do_call_number
    numbers = ("1".."9").to_a
    number = ""
    3.times { number << numbers.sample }
    number
  end
  
  # def self.unique_call_number(meeting_id)
  #   number = Attendance.do_call_number
  #   meeting = Meeting.find(meeting_id)
  #   event = Event.find(meeting.instance.event.id)
  #   @numbers = event.attendances.collect {|a| a.call_number}
  #   @numbers.include?(number) ? Attendance.unique_call_number(meeting_id) : number
  # end
  
  def security_code_must_be_unique_for_event
    errors.add(:security_code, "Security Code is already taken for this event") if Attendance.find_by_code_this_event(self.security_code, self).present?
  end
  
  def call_number_must_be_unique_for_event
    errors.add(:call_number, "Call Number is already taken for this event") if Attendance.find_by_call_number_this_event(self.call_number, self).present?
  end
  
  
  
end
