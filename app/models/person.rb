class Person < ActiveRecord::Base
  
  require_dependency 'date_validator'
  
  belongs_to :household
  has_many :phones, :as => :phonable
  has_many :emails, :as => :emailable
  belongs_to :default_group, :class_name => "Group", :foreign_key => "default_group_id"
  has_many :active_attendances, :class_name => "Attendance",
                                :conditions => {:checkout_time => nil}
  has_many :attendances
  has_many :enrollments
  has_many :current_enrollments, :class_name => "Enrollment",
                                 :conditions => ['enrollments.end_time IS NULL OR enrollments.end_time > ?', Time.now]
  has_many :groups, :through => :enrollments
  has_many :notes, :as => :noteable
  has_many :departments, :class_name => "Department", :foreign_key => "responsible_person_id"
  has_many :ministries, :class_name => "Ministry", :foreign_key => "responsible_person_id"
  has_many :teams, :class_name => "Team", :foreign_key => "responsible_person_id"
  has_many :involvements
  has_many :current_involvements, :class_name => "Involvement",
                                 :conditions => ['involvements.end_date IS NULL OR involvements.end_date > ?', Date.today]
  has_many :taggings
  has_many :tags, :through => :taggings
  has_many :small_groups_i_lead, :class_name => "Group", :foreign_key => "small_group_leader_id"
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  has_many :contacts, :conditions => ['contacts.deleted_at IS NULL'], :order => ['created_at, contact_type_id ASC']
  has_many :contributions, :as => :contributable, :conditions => ['contributions.deleted_at IS NULL']
  has_many :relationships
  has_many :web_relationships, :class_name => 'Relationship', :foreign_key => 'person_id', :conditions => ['relationships.web_access = 1']
  has_many :attendance_trackers, :dependent => :destroy
  has_many :tracked_groups, :through => :attendance_trackers, :source => :group
  has_many :notes, :as => :noteable
  
  has_one :picture
  attr_accessor :uploaded_picture_data
  
  validates_dates :birthdate,
                  :from => '1 Jan 1920',
                  :to => Date.today,
                  :allow_nil => true
  
  validates_presence_of :default_group_id
  validates_presence_of :first_name, :message => "Can't be blank"
  validates_presence_of :last_name, :message => "Can't be blank."
  
  #validates_presence_of :household_id, :message => 'Person must belong to a household.'
  
  acts_as_paranoid
  
  #before_destroy :check_for_enrollments
  
  POSITIONS = [ "Primary Contact", "Spouse", "Dependent", "Friend", "Relative", "Deceased" ]
  GENDERS = ["Female", "Male"]
  FILTER_VALUES = ["All", "Recent Attenders", "Newcomers", "Active Attenders"]
  
  
  
  def self.actives
    Person.find(:all, :conditions => ['attendance_status = ?',"Active"])
  end
  
  def fix_last_name
    if self.last_name.nil?
      'unknown'
    else
      self.last_name
    end
  end
  
  def full_name
    self.first_name + ' ' + self.fix_last_name
  end
  
  def last_first_name
    self.last_name + ', ' + self.first_name
  end
  
  def formatted_birthdate
    unless self.birthdate.blank?
     birthdate.strftime('%m/%d/%Y')
   end
  end
    
   def formatted_birthdate=(time_str)
     self.birthdate = Time.parse(time_str)
   end
   
   def age
     unless self.birthdate.blank?
       age = (Time.now - self.birthdate.to_time)/1.year
       age.floor
     else
        0
     end
   end
  
  def checkin_mod
#    @form_meeting = Meeting.find(:first, :conditions => {:id => params[:attendance][:meeting_id]})
    curr_instance = Setting.one.current_instance
    @default_meeting = Meeting.find(:first, :conditions => {:instance_id => curr_instance, :group_id => self.default_group_id})
    if @form_meeting.nil?
        @meeting = @default_meeting
      else
        @meeting = @form_meeting
    end
    if @meeting.nil?
      else
        @attendance = Attendance.new(:person_id => self.id,
                                     :meeting_id => @meeting.id,
                                     :checkin_type_id => 1,
                                     :checkin_time => Time.now)
    if @attendance.save
    end
    end
  end
  
  def search_order
    self.last_name + "               "[0..15-self.last_name.length] + self.first_name
  end
  
  def url_for
     	"/people/show/#{id}"
	end
		
	def active_attendances_by_instance(instance_id)
	 Attendance.find(:all, :conditions => ['person_id = ? AND meetings.instance_id = ? AND checkout_time IS NULL', self, instance_id],
              :include => [:meeting])
	end
	
	def active_attendances_other_instance_this_event(instance_id,event_id) #active attendances in instances other than this one?
	 Attendance.find(:all, :select => ['attendances.id, meetings.id as meeting_id, instances.id as instance_id, instances.event_id, meetings.group_id'],
	                 :conditions => ['person_id = ? AND meetings.instance_id != ? AND checkout_time IS NULL AND instances.event_id = ?', self, instance_id, event_id],
                     :joins => ['LEFT OUTER JOIN meetings ON (attendances.meeting_id = meetings.id)
                                 LEFT OUTER JOIN instances ON (meetings.instance_id = instances.id)'])
	end
	
	def household_phones
	  Phone.find(:all, :conditions => ['phonable_id = ? AND phones.phoneable_type LIKE ?', self.household_id, "Household"])
	end
	
	def household_first_phone
	  Phone.find(:first, :conditions => ['phonable_id = ? AND phones.phoneable_type LIKE ?', self.household_id, "Household"])
	end
	
	def household_primary_phone
	  Phone.find(:first, :conditions => ['phonable_id = ? AND phones.primary LIKE ?', self.household_id, 1])
	end
	
	def household_emergency_phone
	  @result = self.household_primary_phone
	  @result ||= self.household_first_phone
	  @result
	end
	
	def household_first_email
	 Email.find(:first, :conditions => ['emailable_id = ? AND emails.emailable_type LIKE ?', self.household_id, "Household"])
	end
	
	def household_first_phone
	 Phone.find(:first, :conditions => ['phonable_id = ? AND phones.phonable_type LIKE ?', self.household_id, "Household"])
	end
	
	def household_primary_email
	 Email.find(:first, :conditions => ['emailable_id = ? AND emails.primary LIKE ? AND emails.emailable_type LIKE ?', self.household_id, 1, "Household"])
	end
	
	def household_primary_phone
	 Phone.find(:first, :conditions => ['phonable_id = ? AND phones.primary LIKE ? AND phones.phonable_type LIKE ?', self.household_id, 1, "Household"])
	end
	
	def household_best_email
	  @result = self.household_primary_email
	  @result ||= self.household_first_email
	  @result
	end
	
	def primary_email
	 Email.find(:first, :conditions => ['emailable_id = ? AND emails.primary LIKE ? AND emails.emailable_type LIKE ?', self.id, 1, "Person"])
	end
	
	def primary_phone
	 Phone.find(:first, :conditions => ['phonable_id = ? AND phones.primary LIKE ? AND phones.phonable_type LIKE ?', self.id, 1, "Person"])
	end
	
	def first_email
	 Email.find(:first, :conditions => ['emailable_id = ? AND emails.emailable_type LIKE ?', self.id, "Person"])
	end
	
	def first_phone
	 Phone.find(:first, :conditions => ['phonable_id = ? AND phones.phonable_type LIKE ?', self.id, "Person"])
	end
	
	def first_sms
	 Phone.find(:first, :conditions => ['phonable_id = ? AND phones.phonable_type LIKE ? AND phones.sms_setup_id IS NOT NULL', self.id, "Person"])
	end
	
	def has_sms?
	   self.first_sms.nil? ? false : true
	end
	
	def has_no_sms?
	   return true unless self.first_sms
	end
	
	def best_email
	 @result = self.primary_email
	 @result ||= self.first_email
	 @result ||= self.household_primary_email
	 @result ||= self.household_first_email
	 @result
	end
	
	def best_phone
	 @result = self.primary_phone
	 @result ||= self.first_phone
	 @result ||= self.household_primary_phone
	 @result ||= self.household_first_phone
	 @result
	end
	
	def best_email_smart
	 if ! self.best_email.nil?
	   self.best_email.email
     else
       "none"
     end
	end
	
	def best_phone_smart
	 if ! self.best_phone.nil?
	   self.best_phone.s_formatted
     else
       "none"
     end
	end
	
	
	def household_primary_contact
	 Person.find(:first, :conditions => ['household_id = ? AND household_position LIKE ?', self.household_id, "Primary Contact"])
	end
	
	def household_spouse
	 Person.find(:first, :conditions => ['household_id = ? AND household_position LIKE ?', self.household_id, "Spouse"])
	end
	
	def household_responsible_people
	  @result = Person.find(:all, :conditions => ['(household_id = ? AND household_position = "Primary Contact")
	                                            OR (household_id = ? AND household_position = "Spouse")', self.household_id, self.household_id])
	  @result.collect { |p| p.first_name }.to_sentence
	end
	
	def find_tags
	 Tag.find(:all, :include => [:taggings], :conditions => ['taggings.person_id', self.id])
	end
	
	def find_taggings
	 Tagging.find(:all, :include => [:tag], :conditions => ['taggings.person_id = ?', self.id])
	end
	
	def self.find_all_with_tag(tag_name)
	   Person.find(:all, :select => ['people.id, people.first_name, people.last_name'],
	                :conditions => ['tags.name LIKE ?',tag_name],
	                :joins => ['LEFT OUTER JOIN taggings ON taggings.person_id = people.id
	                            LEFT OUTER JOIN tags ON taggings.tag_id = tags.id'],
	                :group => ['people.id'] )
	end
	
	def self.find_all_with_contact_this_week(contact_type_names)
	   # I don't know where this is used, but it's wrong! weeks.ago should be days.ago... but I don't want to change it until...
	   Person.find(:all, :select => ['people.id, people.first_name, people.last_name,contacts.id, contacts.stamp'],
	                :conditions => ["(contact_types.name IN (?) AND contacts.created_at #{(7.weeks.ago..Time.now).to_s(:db)})",contact_type_names],
	                :joins => ['LEFT OUTER JOIN contacts ON (people.id = contacts.person_id)
	                            LEFT OUTER JOIN contact_types ON (contacts.contact_type_id = contact_types.id)'],
	                :group => ['people.id'] )
	end
	
	def sort_order
	 if self.household_position == "Primary Contact"
	   "1" + "     " + self.birthdate.to_s
   elsif self.household_position == "Spouse"
     "2" + "     " + self.birthdate.to_s
   elsif self.household_position == "Dependent"
     "3" + "     " + self.birthdate.to_s
   elsif self.household_position == "Relative"
     "4" + "     " + self.birthdate.to_s
   elsif self.household_position == "Friend"
     "5" + "     " + self.birthdate.to_s
   else
     "6" + "     " + self.birthdate.to_s
   end
	end
	
	def self.most_recent_attend_date #this works! person 6 has attendances.
	  find(:all, :select => ['people.id, MAX(events.date) as max_date'],
	       :joins => ['LEFT OUTER JOIN attendances ON attendances.person_id = people.id
	                   LEFT OUTER JOIN meetings ON meetings.id = attendances.meeting_id
	                   LEFT OUTER JOIN instances ON instances.id = meetings.instance_id
	                   LEFT OUTER JOIN events ON events.id = instances.event_id'],
	        :group => ['people.id'])
	end
	
	def recent_attend
	 Person.find(:all, :select => ['MAX(events.date) as max_date'],
	       :joins => ['LEFT OUTER JOIN attendances ON attendances.person_id = people.id
	                   LEFT OUTER JOIN meetings ON meetings.id = attendances.meeting_id
	                   LEFT OUTER JOIN instances ON instances.id = meetings.instance_id
	                   LEFT OUTER JOIN events ON events.id = instances.event_id'],
	        :conditions => ['people.id = ?', self.id],
	        :group => ['people.id'])
	end
	
	def recent_attend_this_group(group_id)
	  Attendance.find(:first, :select => ['events.date'],
                    :joins => ["LEFT OUTER JOIN meetings ON meetings.id = attendances.meeting_id AND meetings.group_id = #{group_id}
                                LEFT OUTER JOIN instances ON instances.id = meetings.instance_id
                                LEFT OUTER JOIN events ON events.id = instances.event_id
                                LEFT OUTER JOIN people ON attendances.person_id = people.id"],
                    :order => ['events.date DESC'],
                    :conditions => ['people.id = ? AND events.date IS NOT NULL', self.id])
	end
	
#this is throwing an error on the live app 'statement invalid'
# 3/30/2009     switched ordr of fields in the join people clause
	def recent_attend_new
	    Attendance.find(:first, :select => ['events.date'],
	                    :joins => ['LEFT OUTER JOIN meetings ON meetings.id = attendances.meeting_id
	                                LEFT OUTER JOIN instances ON instances.id = meetings.instance_id
	                                LEFT OUTER JOIN events ON events.id = instances.event_id
	                                LEFT OUTER JOIN people ON people.id = attendances.person_id'],
	                    :order => ['events.date DESC'],
	                    :conditions => ['people.id = ? AND events.date IS NOT NULL', self.id])
    end

#same thing...
# 3/30/2009     same attempt
	def first_attend_new
	    Attendance.find(:first, :select => ['events.date'],
	                    :joins => ['LEFT OUTER JOIN meetings ON meetings.id = attendances.meeting_id
	                                LEFT OUTER JOIN instances ON instances.id = meetings.instance_id
	                                LEFT OUTER JOIN events ON events.id = instances.event_id
	                                LEFT OUTER JOIN people ON people.id = attendances.person_id'],
	                    :order => ['events.date ASC'],
	                    :conditions => ['people.id = ? AND events.date IS NOT NULL', self.id])
  end
  
#this is throwing an error on the live app 'statement invalid' - it will not fail on my development system
# 3/30/2009     switched the order of fields in the join people clause... wild guess
  def first_attend_this_group(group_id) 
    Attendance.find(:first, :select => ['events.date'],
                    :joins => ["LEFT OUTER JOIN meetings ON meetings.id = attendances.meeting_id AND meetings.group_id = #{group_id}
                                LEFT OUTER JOIN instances ON instances.id = meetings.instance_id
                                LEFT OUTER JOIN events ON events.id = instances.event_id
                                LEFT OUTER JOIN people ON people.id = attendances.person_id"],
                    :order => ['events.date ASC'],
                    :conditions => ['people.id = ? AND events.date IS NOT NULL', self.id])
  end
	
	def first_attend #this is wrong, it should find an attendance record not a person record.
	 Person.find(:all, :select => ['MIN(events.date) as min_date'],
	       :joins => ['LEFT OUTER JOIN attendances ON attendances.person_id = people.id
	                   LEFT OUTER JOIN meetings ON meetings.id = attendances.meeting_id
	                   LEFT OUTER JOIN instances ON instances.id = meetings.instance_id
	                   LEFT OUTER JOIN events ON events.id = instances.event_id'],
	        :conditions => ['people.id = ?', self.id],
	        :group => ['people.id'])
	end
	
	def has_household_emails?
	 return true unless self.household.emails.empty? or self.household.emails.nil?
	end
	
	def no_household_emails?
	 return true if self.household.emails.empty? or self.household.emails.nil?
	end
	
	def no_best_email?
	 return true if self.best_email.nil? or self.best_email.email.blank?
	end
	
	def attended_events
	 Event.find(:all, :select => ['events.id, events.date'],
	                  :joins => ['INNER JOIN instances ON instances.event_id = events.id
	                              INNER JOIN meetings ON meetings.instance_id = instances.id
	                              INNER JOIN attendances ON attendances.meeting_id = meetings.id'],
	                  :conditions => ['attendances.person_id = ?', self.id])
	end
	
	def attended_worship_services
	 Event.find(:all, :select => ['events.id, events.date'],
	                  :joins => ['INNER JOIN instances ON instances.event_id = events.id
	                              INNER JOIN meetings ON meetings.instance_id = instances.id
	                              INNER JOIN attendances ON attendances.meeting_id = meetings.id
	                              INNER JOIN groups ON meetings.group_id = groups.id'],
	                  :conditions => ['(attendances.person_id = ?) AND (groups.name LIKE ?)', self.id, 'adult worship'])
	end
	
	def groups_attended
	   @groups = self.attendances.collect { |a| a.meeting.group.name rescue nil }
	   @names = @groups.compact.uniq
	   @result = @names.collect {|g| Group.find_by_name(g)}
	   @result
	end
	
	def attended_event?(event_id)
	 @event_list = self.attended_events.collect(&:id)
	 @event_list.include?(event_id)
	end
	
# 3/30/2009     tried switching order of fields in join clauses
	def attended_meetings
	 Meeting.find(:all, :select => ['meetings.id, events.date, groups.id as group_id'],
	                    :joins => ['INNER JOIN attendances ON attendances.meeting_id = meetings.id
	                                LEFT OUTER JOIN instances ON instances.id = meetings.instance_id 
	                                LEFT OUTER JOIN events ON events.id = instances.event_id 
	                                LEFT OUTER JOIN groups ON groups.id = meetings.group_id'],
	                    :conditions => ['attendances.person_id = ?', self.id])
	end
	
	def attended_meetings_this_group(group_id)
	  Meeting.find(:all, :select => ['meetings.id, events.date, groups.id as group_id'],
  	                    :joins => ['INNER JOIN attendances ON attendances.meeting_id = meetings.id
  	                                LEFT OUTER JOIN instances ON meetings.instance_id = instances.id
  	                                LEFT OUTER JOIN events ON instances.event_id = events.id
  	                                LEFT OUTER JOIN groups ON meetings.group_id = groups.id'],
  	                    :conditions => ['(attendances.person_id = ?) AND (groups.id = ?)', self.id, group_id])
	end
	
# def attended_worship_services
#  Meeting.find(:all, :select => ['meetings.id, events.date, groups.id as group_id'],
#                     :joins => ['INNER JOIN attendances ON attendances.meeting_id = meetings.id
#                                 LEFT OUTER JOIN instances ON meetings.instance_id = instances.id
#                                 LEFT OUTER JOIN events ON instances.event_id = events.id
#                                 LEFT OUTER JOIN groups ON meetings.group_id = groups.id'],
#                     :conditions => ['(attendances.person_id = ?) AND groups.name LIKE ?', self.id, 'adult worship'])
# end
	
	def attended_meeting?(meeting_id)
	 @meeting_list = self.attended_meetings.collect(&:id)
	 @meeting_list.include?(meeting_id)
	end
	
	def self.find_recent_attenders
	  #finds people who have attended at least once in the last 5 weeks.
	  the_date = (Time.now - 5.weeks).strftime('%Y-%m-%d')
	  group_id = Group.find_by_name('Adult Worship')
	  Person.find(:all,
                :include => [:household, :enrollments],
                :conditions => ["(people.max_date >= ?) AND (enrollments.group_id = ?)", the_date, group_id],
                :order => ['people.last_name, people.first_name ASC'])
               
	end
	
	def self.find_newcomers
	  #finds people who have attended between 1 and 4 times AND at least once in the last 5 weeks.
	  the_date = (Time.now - 5.weeks).strftime('%Y-%m-%d')
	  the_range = "1 AND 4"
	  group_id = Group.find_by_name('Adult Worship')
	  Person.find(:all,
                :include => [:household, :enrollments],
                :conditions => ["(people.max_date >= ?) AND (people.attend_count BETWEEN #{the_range}) AND (enrollments.group_id = ?)",the_date, group_id],
                :order => ['people.last_name, people.first_name ASC'])
    end
    
    def self.find_active_attenders
  	  #finds people who have attended more than 3 times AND at least once in the last 5 weeks.
  	  group_id = Group.find_by_name('Adult Worship')
  	  Person.find(:all,
                  :include => [:household, :enrollments],
                  :conditions => ['people.attendance_status LIKE ? AND enrollments.group_id = ?', 'Active', group_id],
                  :order => ['people.last_name, people.first_name ASC'])
    end
      
    def list_attendances(the_group_id,range_result,self_id)
        sql_conditions = []
        unless range_result == "All"
          if range_result == "This Month"
            start_range = Time.now.beginning_of_month
            end_range = Time.now
          elsif range_result == "Last 30 Days"
            start_range = (Time.now - 30.days)
            end_range = Time.now
          elsif range_result == "This Week"
              start_range = Time.now.beginning_of_week
              end_range = Time.now
          elsif range_result == "Last 7 Days"
              start_range = (Time.now - 7.days)
              end_range = Time.now
          elsif range_result == "Last 14 Days"
              start_range = (Time.now - 14.days)
              end_range = Time.now
          elsif range_result == "Year To Date"
              start_range = Time.now.beginning_of_year
              end_range = Time.now
          end
          range_condition = Caboose::EZ::Condition.new :events do
            date <=> (start_range..end_range)
          end
          sql_conditions << range_condition
        end
        
        group_cond = Caboose::EZ::Condition.new :meetings do
            group_id == the_group_id
        end
        sql_conditions << group_cond
        
        self_cond = Caboose::EZ::Condition.new :attendances do
            person_id == self_id
        end
        sql_conditions << self_cond
        
        combined_cond = Caboose::EZ::Condition.new
        sql_conditions.each do |item|
          combined_cond << item
        end
        
      Attendance.find(:all,
                      :include => [:meeting => [:instance => [:event]]],
                      :conditions => combined_cond.to_sql,
                      :order => ['events.date DESC, events.event_type_id, instances.instance_type_id, meetings.group_id ASC'])
    end
    
    def set_recent_attend
      self.update_attribute(:max_date, self.recent_attend_new[:date]) if self.recent_attend_new
      #set_first_attend
    end
    
    def set_first_attend # min_date is a date field
      self.update_attribute(:min_date, self.first_attend_new[:date]) if self.first_attend_new
      #set_attend_count
    end
    
    def set_attend_count
      self.update_attribute(:attend_count, self.attended_meetings.length)
      #set_second_attend
    end
    
#this is part of the mysterious error in the live app...
    def set_second_attend # datetime
        self.update_attribute(:second_attend, self.attended_events.collect {|e| e.date.to_s}.uniq.sort[-2]) unless self.attended_meetings.length < 2
        #set_attendance_status
      #rescue
    end
    
    def set_max_worship_date #date
        self.update_attribute(:max_worship_date, self.attended_worship_services.collect {|e| e.date.to_s}.uniq.sort.last) unless self.attended_worship_services.empty?
    end
    
    def set_recent_contr
      self.update_attribute(:recent_contr, self.contributions.collect {|e| e.date}.uniq.sort.last) unless self.contributions.empty?
    end
    
    def set_contr_count
      self.update_attribute(:contr_count, self.contributions.empty? ? "0" : self.contributions.length)
    end
    
    def set_worship_attends
        self.update_attribute(:worship_attends, self.attended_worship_services.collect {|e| e.date.to_s}.uniq.length) unless self.attended_worship_services.empty?
        #set_max_worship_date
    end
    
    def self.set_status_advance_decline
        Setting.find(1).update_attribute(:advance_decline_run_date, Time.now)
        #guest advance group...
        @guest_advance_group = Person.find(:all,
                                           :conditions => ["attend_count = 3 AND max_date > '#{(Time.now - 6.days).to_date}'"])
            @guest_advance_group.each do |person|
                person.tag_for_advance_decline_instance("Guest Advance")
            end
                    
        @inactive_advance_group = Person.find(:all,
                                              :conditions => ["attend_count > ? AND 
                                                               max_date > '#{(Time.now - 7.days).to_date}' AND 
                                                               second_attend <= ?", 1, (current_time - 5.weeks)])
            @inactive_advance_group.each do |person|
                person.tag_for_advance_decline_instance("Inactive Advance")
            end
        
        @active_decline_group = Person.find(:all,
                                            :conditions => ["attend_count > 2 AND
                                                             max_date BETWEEN '#{((Time.now - 41.days).to_date)}' AND '#{((Time.now - 5.weeks).to_date)}'"])
            @active_decline_group.each do |person|
                person.tag_for_advance_decline_instance("Active Decline")
            end
        
        @guest_decline_group = Person.find(:all,
                                           :conditions => ["attend_count BETWEEN 1 AND 2 AND
                                                            max_date BETWEEN '#{((Time.now - 41.days).to_date)}' AND '#{((Time.now - 5.weeks).to_date)}'"])
           @guest_decline_group.each do |person|
               person.tag_for_advance_decline_instance("Guest Decline")
           end
    end
    
    def tag_for_advance_decline_instance(advance_decline_instance)
        @tag = Tag.find_by_name(advance_decline_instance)
        @tagging = Tagging.new(:tag_id => @tag.id, :person_id => self.id,
                           :created_at => Time.now, :created_by => "system",
                           :comments => "created by system for #{advance_decline_instance} instance. Max Date: #{self.max_date}, Attend Count: #{self.attend_count}, Second Attend Date: #{second_attend rescue nil}",
                           :start_date => Time.now)
        @tagging.save unless self.has_tag_this_week?(@tagging.tag.id)
    end
    
    
    def set_status_advance_decline_old # delete this one
        unless self.max_date.nil?
        #handle guest advance...
        if self.attend_count == 3 and self.max_date > ((Time.now - 7.days).to_date)
                @tag = Tag.find_by_name("Guest Advance")
                @tagging = Tagging.new(:tag_id => @tag.id, :person_id => self.id,
                                   :created_at => Time.now, :created_by => "system",
                                   :comments => "created by system for guest advance instance.",
                                   :start_date => Time.now)
                @tagging.save unless self.has_tag_this_week?(@tagging.tag.id)
        end
        #handle inactive advance...
        if self.attend_count > 1 and self.max_date > ((Time.now - 7.days).to_date) and self.second_attend < (Time.now - 5.weeks)
                @tag = Tag.find_by_name("Inactive Advance")
                @tagging = Tagging.new(:tag_id => @tag.id, :person_id => self.id,
                                   :created_at => Time.now, :created_by => "system",
                                   :comments => "created by system for inactive advance instance.",
                                   :start_date => Time.now)
                @tagging.save unless self.has_tag_this_week?(@tagging.tag.id)
         end       
        #handle active decline...
        if self.attend_count > 2 and self.max_date > ((Time.now - 6.weeks).to_date) and self.max_date < ((Time.now - 5.weeks).to_date)
                 @tag = Tag.find_by_name("Active Decline")
                 @tagging = Tagging.new(:tag_id => @tag.id, :person_id => self.id,
                                    :created_at => Time.now, :created_by => "system",
                                    :comments => "created by system for active decline instance.",
                                    :start_date => Time.now)
                 @tagging.save unless self.has_tag_this_week?(@tagging.tag.id)
         end   
        #handle guest decline...
        if self.attend_count > 0 and self.attend_count < 4 and self.max_date > ((Time.now - 6.weeks).to_date) and self.max_date < ((Time.now - 5.weeks).to_date)
                @tag = Tag.find_by_name("Guest Decline")
                @tagging = Tagging.new(:tag_id => @tag.id, :person_id => self.id,
                                   :created_at => Time.now, :created_by => "system",
                                   :comments => "created by system for guest decline instance.",
                                   :start_date => Time.now)
                @tagging.save unless self.has_tag_this_week?(@tagging.tag.id)
         end
     end
    end
    
    def set_attendance_status
            if self.household_position == "Deceased"
                status = "Deceased"
            elsif self.max_date.nil?
                status = "Inactive"
            elsif self.max_date < ((Time.now - 5.weeks).to_date)
                status = "Inactive"
            elsif self.attend_count < 3 and self.max_date > ((Time.now - 5.weeks).to_date)
                status = "Guest"
            elsif attend_count > 2 and self.max_date > ((Time.now - 5.weeks).to_date)
                status = "Active"
            end
        self.update_attribute(:attendance_status, status)
    end
    
    def self.set_attendance_statuses_old #delete this one
        @people = Person.find(:all, :conditions => ["max_date > ?", (Time.now - 9.weeks).to_date])
        @people.each do |p|
            if p.max_date.nil?
                status = "Inactive"
            elsif p.max_date < ((Time.now - 5.weeks).to_date)
                status = "Inactive"
            elsif p.attend_count < 3 and p.max_date > ((Time.now - 5.weeks).to_date)
                status = "Guest"
            elsif p.attend_count > 2 and p.max_date > ((Time.now - 5.weeks).to_date)
                status = "Active"
            end
            p.update_attribute(:attendance_status, status) 
        end
    end
    
    def self.set_attendance_statuses
        @inactives = Person.find(:all,
                                 :conditions => ['max_date IS NULL OR max_date < ? AND attendance_status <> ?', (Time.now - 5.weeks).to_date,"Inactive"])
            @inactives.each do |p|
                p.do_status_change("Inactive")
                p.household.set_attendance_status if p.household
            end
        @guests = Person.find(:all,
                              :conditions => ['attend_count < ? AND max_date > ? AND attendance_status <> ?', 3, (Time.now - 5.weeks).to_date, "Guest"])
            @guests.each do |p|
                p.do_status_change("Guest")
            end
        @actives = Person.find(:all,
                               :conditions => ['attend_count > ? AND max_date > ? AND attendance_status <> ?', 2, (Time.now - 5.weeks).to_date, "Active"])
            @actives.each do |p|
                p.do_status_change("Active")
            end
    end
    
    def do_status_change(new_status)
        self.update_attribute(:attendance_status, new_status)
    end
    
#throwing an error 'statement invalid'
    def enroll_in_group(group_id)
        @enrollment = Enrollment.new(:person_id => self.id, :group_id => group_id)
        @enrollment.save
    end
    
    def check_for_guest_flow_contacts
        if self.enrolled_in_group?("Adult Worship")
            if self.max_worship_date > (Time.now - 6.days).to_date && self.worship_attends == 1
                type = "1st Visit Letter"
            elsif self.max_worship_date > (Time.now - 6.days).to_date && self.worship_attends == 2
                type = "2nd Visit Letter"
            elsif self.max_worship_date > (Time.now - 6.days).to_date && self.worship_attends == 3
                type = "3rd Visit Letter"
            elsif self.max_worship_date > (Time.now - 6.days).to_date && self.worship_attends == 4
                type = "Newcomer Call"  
            end
#          elsif self.max_date > (Time.now - 13.days).to_date && self.max_date < (Time.now - 6.days).to_date && self.attend_count < 4
#              type = "Missed You Letter"
#          elsif self.attendance_status == "Active" && self.max_date > (Time.now - 27.days).to_date && self.max_date < (Time.now - 20.days).to_date
#              type = "Active At Risk"
#          end
            if self.max_worship_date > (Time.now - 6.days).to_date && self.worship_attends == 1
                another = "Guest Reception Invite"
            end
        end

        if type
            self.do_guest_flow_contact(type)
        end
        if another
            type = another
            self.do_guest_flow_contact(type)
        end
    end
    
    def self.do_auto_contacts
        @missed_yous = Person.find(:all,
                                   :conditions => ['worship_attends < ? AND max_worship_date > ? AND max_worship_date < ?',4, (Time.now - 13.days).to_date, (Time.now - 6.days).to_date])
            @missed_yous.each do |p|
                p.enrolled_in_group?("Adult Worship") ? p.do_guest_flow_contact("Missed You Letter") : false
            end
        @actives_at_risk = Person.find(:all,
                                       :conditions => ['attend_count > ? AND max_date < ? AND max_date > ?', 3, (Time.now - 27.days), (Time.now - 34.days)])
            @actives_at_risk.each do |p|
                p.enrolled_in_group?("Adult Worship") ? p.do_guest_flow_contact("Active At Risk") : false
            end
    end
    
    def do_guest_flow_contact(type)
        @contact_type = ContactType.find_by_name(type)
        if @contact_type
            @contact = Contact.new(:contact_type_id => @contact_type.id, :created_by => User.current_user.login,
                                   :responsible_user_id => @contact_type.default_responsible_user_id,
                                   :comments => "created by system for auto-detected #{type} instance", :openn => true,
                                   :person_id => self.id)
            @contact.save unless self.has_contact_type_this_week?(@contact.contact_type_id)
        end
    end
    
    def do_keep_phones(phones_to_keep)
        self.phone_ids=phones_to_keep
    end
    
    def do_keep_emails(emails_to_keep)
        self.email_ids=emails_to_keep
    end
    
    def merge_enrollments(duplicate_id)
        @dup = Person.find(duplicate_id)
        @dup.enrollments.each do |e|
            unless e.update_attributes(:person_id => self.id)
                e.destroy
            end
        end
    end
    
    def merge_involvements(duplicate_id)
        @dup = Person.find(duplicate_id)
        @keeper_jobs = self.involvements.collect {|j| j.job_id}
        @dup.involvements.each do |d|
            #determine if keeper already has the job... if not, bring it over... WITH all assignments...
            if ! @keeper_jobs.include?(d)
                #if the dup involvement won't update to keeper (won't validate), destroy the involvement...
                unless d.update_attributes(:person_id => self.id)
                    d.destroy
                end
            #keeper already has job... now what? ...deal with assignments...
            elsif ! d.assignments.empty? # what if the involvement has assignments?
                #move the dups assignmemnts to the keeper's involvement record... and destroy dups involvement record...
                @keeper_involvement = Involvement.find_by_person_id_and_job_id(self.id,d.id)
                d.assignments.each do |a|
                    unless a.update_attributes(:involvement_id => @keeper_involvement.id)
                    end
                end
                d.destroy
            else #the involvement has no assignments... and keeper already has this job... simply destroy the involvement, right?
                d.destroy
            end
        end
    end
    
    def merge_attendances(duplicate_id)
        @dup = Person.find(duplicate_id)
        @dup.attendances.each do |a|
            #needs to validate... or be destroyed...
            unless a.update_attributes(:person_id => self.id)
                a.destroy
            end
        end
    end
    
    def merge_taggings(duplicate_id)
        @dup = Person.find(duplicate_id)
        @dup.taggings.each do |t|
            t.update_attribute(:person_id, self.id)
        end
    end
    
    def merge_contacts(duplicate_id)
        @dup = Person.find(duplicate_id)
        @dup.contacts.each do |c|
            c.update_attribute(:person_id, self.id)
        end
    end
    
    def merge_contributions(duplicate_id)
        @dup = Person.find(duplicate_id)
        @dup.contributions.each do |g|
            g.update_attribute(:person_id, self.id)
        end
    end
    def has_tag_this_week?(tag_id)
        now = (Time.now + 1.days)
        one_week_ago = (Time.now - 6.days)
        @taggings = Tagging.find(:all,
                                  :conditions => ["(taggings.person_id = ?) AND (taggings.start_date BETWEEN '#{one_week_ago.to_date.to_s}' and '#{now.to_date.to_s}')",self.id])
        @taggings.collect {|t| t.tag_id}.include?(tag_id)
    end
    
    def has_contact_type_this_week?(contact_type_id)
        now = (Time.now + 1.days)
        one_week_ago = (Time.now - 6.days)
        @contacts = Contact.find(:all,
                                  :conditions => ["(contacts.person_id = ?) AND (contacts.created_at BETWEEN '#{one_week_ago.to_date.to_s}' and '#{now.to_date.to_s}')",self.id])
        @contacts.collect {|c| c.contact_type_id}.include?(contact_type_id)
    end
    
    def save_picture
        picture = Picture.new
        begin
            self.transaction do
                if uploaded_picture_data && uploaded_picture_data.size > 0
                    picture.uploaded_data = uploaded_picture_data
                    picture.thumbnails.clear
                    picture.save!
                    self.picture = picture
                end
                save!
            end
        rescue ActiveRecord::RecordInvalid
            if picture.errors.on(:size)
                errors.add_to_base("Uploaded image is too big (500-KB max)." )
            end
            if picture.errors.on(:content_type)
                errors.add_to_base("Uploaded image content-type is not valid." )
            end
            false
        rescue Exception => e
            errors.add_to_base(e.message)
            false
        end
        self.update_attribute(:has_a_picture, self.picture ? true : false)
    end
    
    def enrolled_in_group?(group_name)
        @group_names = self.enrollments.collect {|e| e.group.name unless e.group.nil? }
        @group_names.include?(group_name)
    end
    
    def jobs_by_team(team_id)
        Job.find(:all, :conditions => ['jobs.team_id = ? AND involvements.person_id = ?', team_id,self.id],
                 :joins => ['INNER JOIN involvements ON (jobs.id = involvements.job_id)'])
                
    end
    
    def self.find_by_status_and_group_enrollment(status, group_name)
        Person.find(:all,
                    :conditions => ['(attendance_status IN (?)) AND (groups.name IN (?))',status,group_name],
                    :joins => ['LEFT OUTER JOIN enrollments ON (people.id = enrollments.person_id)
                                LEFT OUTER JOIN groups ON (groups.id = enrollments.group_id)'],
                    :group => ['people.id'])
    end
    
    def self.find_all_enrolled_in_group(group_name)
        Person.find(:all,
                    :select => ['people.id, people.first_name, people.last_name, people.household_id'],
                    :joins => ['LEFT OUTER JOIN enrollments ON people.id = enrollments.person_id
                                LEFT OUTER JOIN groups ON groups.id = enrollments.group_id'],
                    :include => :household,
                    :conditions => ['groups.name LIKE ?', group_name],
                    :order => ['households.name, people.first_name ASC'])
    end
    
    def family_name
        if self.last_name == self.household.name
            self.first_name
        else
            self.first_name + ' ' + self.last_name
        end
    end
    
    def to_vcard
      begin
        card = Vpim::Vcard::Maker.make2 do |maker|
            maker.add_name do |name|
                name.given = self.first_name
                name.family = self.last_name
            end
            if self.household
              maker.add_addr do |addr|
                  addr.location = 'home'
                  addr.street = self.household.address1
                  addr.locality = self.household.city
                  addr.region = self.household.state
                  addr.postalcode = self.household.zip.to_s
              end
            end
           
      #  maker.add_tel(self.best_phone_smart) do |tel|
      #      tel.location = 'home'
      #      tel.preferred = true
      #  end
            
           self.phones.each do |phone|
              maker.add_tel(phone.s_formatted) do |tel|
                tel.location = phone.comm_type.name
                tel.preferred = phone.primary?
              end
            end

            if self.household
              self.household.phones.each do |phone|
                maker.add_tel(phone.s_formatted) do |tel|
                  tel.location = phone.comm_type.name
                  tel.preferred = phone.primary?
                end
              end
           end
            
            if self.first_email
              self.emails.each do |person_email|
                maker.add_email(person_email.email) {|e| e.location = person_email.comm_type.name rescue nil} unless person_email.email.blank?
              end
            end
            if self.household
              self.household.emails.each do |household_email|
                maker.add_email(household_email.email) {|f| f.location = household_email.comm_type.name rescue nil} unless household_email.email.blank?
              end
            end
            maker.birthday = self.birthdate unless self.birthdate.nil? or self.birthdate.blank?
            #end
#   if self.picture
#   maker.add_photo do |photo|
#       photo.image = File.open(self.picture.full_filename.to_s).read
#       photo.type = 'jpeg'
#   end
#   end
            
        end
        
        if self.picture
          photodata = [File.open(self.picture.full_filename.to_s).read].pack('m').to_s
          photodata = photodata.gsub(/[ \n]/, '').scan(/.{1,76}/).join("\n  ")
          card.to_s.sub!('END:VCARD', "PHOTO;BASE64:\n  " + photodata + "\nEND:VCARD")
        end
        card.to_s
      rescue
      end
    end
    
    def all_relationships
      Relationship.find(:all, :conditions => ['relationships.person_id = ? OR relationships.relates_to_id = ?', self.id, self.id])
    end
    
    def do_attendance_tracker(meeting_id)
      meeting = Meeting.find(meeting_id)
      tracker = AttendanceTracker.find_or_create_by_person_id_and_group_id(self.id,meeting.group.id)
      if !self.attended_meetings_this_group(meeting.group.id).empty?
        new_values = {:most_recent_attend => self.recent_attend_this_group(meeting.group.id)[:date].to_time,
                      :first_attend => self.first_attend_this_group(meeting.group.id)[:date].to_time,
                      :count => self.attended_meetings_this_group(meeting.group.id).length}
        tracker.update_attributes(new_values)
      else
        tracker.destroy
      end
    end
    
    def fullname
        "#{firstname} #{lastname}"
    end
    
    def set_enrolled
      self.update_attribute(:enrolled, self.current_enrollments.empty? ? false : true)
    end
    
    def set_involved
      self.update_attribute(:involved, self.current_involvements.empty? ? false : true)
    end
    
    def set_connected
      self.update_attribute(:connected, (self.enrolled? or self.involved?) ? true : false)
    end
    
    def to_ldap_entry
    		{	
    		  "objectclass"     => ["top", "person", "organizationalPerson", "inetOrgPerson", "mozillaOrgPerson"],
    			"uid"             => ["tbotter-#{id}"],
     			"sn"              => [lastname],
      		"givenName"       => [firstname],
    			"cn"              => [fullname],
      		"title"           => [title],
      		"o"               => [company], 
      		"mail"            => [email],
      		"telephonenumber" => [work_phone], 
      		"homephone"       => [home_phone],
      		"fax"             => [fax],
      		"mobile"          => [mobile],
      		"street"          => [address],
      		"l"               => [city],
      		"st"              => [state], 
      		"postalcode"      => [zip], 
    		}
    	end
    	
    	def self.search(query)
          Person.find(:all, 
                      :conditions => ["(first_name LIKE ?) OR (last_name LIKE ?)", 
                                      "#{query}%", "#{query}%"])
        end
    
                                    
    
#  private 
#  def check_for_enrollments    ## This is stupid!
#      if ! self.enrollments.empty?
#          errors.add_to_base("#{self.full_name} is enrolled in #{self.enrollments.length} group(s). First, remove #{self.first_name} from all groups. Then try again.")
#          false
#      end
#      if ! self.involvements.empty?
#          errors.add_to_base("#{self.full_name} is involved in #{self.involvements.length} team(s). First, remove #{self.first_name} from all teams. Then try again.")
#          false  
#      end
#  end

  
end
