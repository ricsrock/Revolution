require 'vpim/vcard'
require 'open-uri'

class Person < ActiveRecord::Base
  
  POSITIONS = [ "Primary Contact", "Spouse", "Dependent", "Friend", "Relative", "Deceased" ]
  GENDERS = ["Female", "Male"]
  FILTER_VALUES = ["All", "Recent Attenders", "Newcomers", "Active Attenders"]
  STATUSES = ["Active", "Inactive", "Guest", "Deceased"]
  ADVANCE_DECLINE_VALUES = ["Guest Advance", "Guest Decline", "Inactive Advance", "Active Decline"]
  AUTO_CONTACT_VALUES = ["Missed You Letter", "Active At Risk", "Newcomer Call", "Guest Reception Invite", "1st Visit Letter", "2nd Visit Letter", "3rd Visit Letter"]
  
  belongs_to :household, inverse_of: :people
  belongs_to :default_group, :class_name => "Group", :foreign_key => "default_group_id"
  
  # If you add a has_many, you MUST add that association to the merge process!
  has_many :phones, :as => :phonable, dependent: :destroy
  has_many :emails, :as => :emailable, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :attended_meetings, -> { uniq }, through: :attendances, source: :meeting#, uniq: true
  has_many :attended_instances, -> { uniq }, through: :attended_meetings, source: :instance#, uniq: true
  has_many :attended_events, -> { uniq }, through: :attended_instances, source: :event#, uniq: true
  has_many :enrollments, dependent: :destroy
  has_many :groups, through: :enrollments
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :attendance_trackers, dependent: :destroy
  has_many :contacts, as: :contactable, dependent: :restrict_with_exception
  has_many :contributions, as: :contributable, dependent: :restrict_with_exception
  
  validates :first_name, :gender, :default_group_id, :attendance_status, presence: true
  validates :attendance_status, inclusion: { :in => Person::STATUSES }
  validates_presence_of :household
  
  mount_uploader :image, ImageUploader
  
  before_save :set_last_name
  before_validation :set_initial_status, on: :create
  before_validation :set_facebook_uid
  
  delegate :address1, to: :household
  delegate :address2, to: :household
  delegate :city, to: :household
  delegate :state, to: :household
  delegate :zip, to: :household
  
  acts_as_stampable
  
  # ransacker :full_name do |parent|
  #   Arel::Nodes::InfixOperation.new('||',
  #     Arel::Nodes::InfixOperation.new('||', parent.table[:first_name], ' '),
  #     parent.table[:last_name])
  # end
  
  ransacker :full_name, :formatter => proc {|v| v.downcase } do |parent|
      Arel::Nodes::NamedFunction.new('LOWER',
        [Arel::Nodes::NamedFunction.new('concat_ws', [' ', parent.table[:first_name], parent.table[:last_name]])]
      )
  end
  
  ransacker :last_first_name, :formatter => proc {|v| v.downcase } do |parent|
      Arel::Nodes::NamedFunction.new('LOWER',
        [Arel::Nodes::NamedFunction.new('concat_ws', [' ', parent.table[:last_name], parent.table[:first_name]])]
      )
  end
  
  
  # after_save :set_image_present
    
  def self.actives
    people = Arel::Table.new(:people)
    where(people[:attend_count].gt(2)).where(people[:max_date].gt((Time.zone.now - 5.weeks).to_date.to_s(:db)))
    # where('people.attend_count > ?', '2').where('people.max_date > ?', (Time.now - 5.weeks).to_date.to_s(:db))
  end
  
  def self.inactives
    people = Arel::Table.new(:people)
    where(people[:max_date].eq(nil).or(people[:max_date].lt((Time.zone.now - 5.weeks).to_date.to_s(:db))))
  end
  
  def self.guests
    people = Arel::Table.new(:people)
    where(people[:attend_count].lt(3)).where(people[:max_date].gt((Time.zone.now - 5.weeks).to_date.to_s(:db)))
  end
  
  def self.guest_advances
    people = Arel::Table.new(:people)
    where(people[:attend_count].eq(3)).where(people[:max_date].gt((Time.zone.now - 6.days).to_date.to_s(:db)))
  end
  
  def self.guest_declines
    people = Arel::Table.new(:people)
    where(people[:attend_count].in(2..3)).
    where(people[:max_date].in((Time.zone.now - 41.days).to_date.to_s(:db)..(Time.zone.now - 5.weeks).to_date.to_s(:db)))
  end
  
  def self.inactive_advances
    people = Arel::Table.new(:people)
    where(people[:max_date].gt((Time.zone.now - 6.days).to_date.to_s(:db))).         #attended this week
    where(people[:second_attend].lt((Time.zone.now - 34.days).to_date.to_s(:db)))    #second most recent attend was over 5 weeks ago (34 days or more)
  end
  
  def self.active_declines
    people = Arel::Table.new(:people)
    where(people[:attend_count].gt(2)).                                                                           #attended 3 or more times
    where(people[:max_date].in((Time.zone.now - 41.days).to_date.to_s(:db)..(Time.zone.now - 5.weeks).to_date.to_s(:db)))   #most recent attend over 5 weeks ago as of this week
  end
  
  def self.active_at_risks
    people = Arel::Table.new(:people)
    self.actives.where(people[:max_date].lt((Time.zone.now - 4.weeks).to_date.to_s(:db)))
  end
  
  def self.missed_you_letters
    people = Arel::Table.new(:people)
    where(people[:attend_count].lt(4)).
    where(people[:max_date].gt((Time.zone.now - 2.weeks).to_date.to_s(:db))).
    where(people[:max_date].lt((Time.zone.now - 1.week).to_date.to_s(:db)))
  end
  
  def self.first_visit_letters
    people = Arel::Table.new(:people)
    where(people[:worship_attends].eq(1)).
    where(people[:max_worship_date].gt((Time.zone.now - 6.days).to_date.to_s(:db)))
  end
  
  def self.second_visit_letters
    people = Arel::Table.new(:people)
    where(people[:worship_attends].eq(2)).
    where(people[:max_worship_date].gt((Time.zone.now - 6.days).to_date.to_s(:db)))
  end
  
  def self.third_visit_letters
    people = Arel::Table.new(:people)
    where(people[:worship_attends].eq(3)).
    where(people[:max_worship_date].gt((Time.zone.now - 6.days).to_date.to_s(:db)))
  end
  
  def self.newcomer_calls
    people = Arel::Table.new(:people)
    where(people[:worship_attends].eq(4)).
    where(people[:max_worship_date].gt((Time.zone.now - 6.days).to_date.to_s(:db)))
  end
  
  def self.guest_reception_invites
    people = Arel::Table.new(:people)
    where(people[:worship_attends].eq(1)).
    where(people[:max_worship_date].gt((Time.zone.now - 6.days).to_date.to_s(:db)))
  end
  
  # when is this called?
  def self.set_statuses
    statuses = Person::STATUSES
    statuses.delete('Deceased')
    statuses.each do |status|
      Person.send(status.downcase.pluralize.to_sym).update_all(attendance_status: status)
    end
  end
  
  def self.create_advance_decline_tags
    values = Person::ADVANCE_DECLINE_VALUES
    values.each do |v|
      people = Person.send(v.sub(" ", "").underscore.downcase.pluralize.to_sym)
      people.to_a.each { |p| p.tag_for_advance_decline_instance(v) unless p.has_tag_in_last_six_days?(v) }
    end
  end
  
  def self.create_auto_contacts
    values = Person::AUTO_CONTACT_VALUES
    values.each do |v|
      if v.starts_with?("1")
        m = "First Visit Letter"
      elsif v.starts_with?("2")
        m = "Second Visit Letter"
      elsif v.starts_with?("3")
        m = "Third Visit Letter"
      else
        m = v
      end
      people = Person.send(m.gsub(" ", "").underscore.pluralize.to_sym)
      people.to_a.each { |p| p.create_auto_contact(v) unless p.has_contact_in_last_six_days?(v) }
    end
  end
  
  def age
    unless self.birthdate.blank?
      dob = self.birthdate.to_date
      now = Time.zone.now.to_date
      now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    else
       0
    end
  end
  
  def age_on(date)
    unless self.birthdate.blank?
      now = date.to_date
      dob = self.birthdate.to_date
      now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    else
      0
    end
  end
  
  def attendances_this_year
    attendances.where('events.date >= ?', Time.now.beginning_of_year.to_date).includes(meeting: {instance: :event}).references(:meetings, :instances, :events)
  end
  
  def attended_groups
    Group.where('attendances.person_id = ?', self.id).select('DISTINCT groups.*').includes(:meetings => :attendances).references(:meetings, :attendances)
  end
  
  def unique_events_this_year
    attended_events.where('events.date >= ?', Time.zone.now.beginning_of_year.to_date.to_s(:db))
  end
  
  def tag_for_advance_decline_instance(v)
    @tag = Tag.find_by_name(v)
    @tagging = Tagging.new(:tag_id => @tag.id, :person_id => self.id,
                           :created_by => "system",
                           :comments => "created by system for #{v} instance. Max Date: #{self.max_date}, Attend Count: #{self.attend_count}, Second Attend Date: #{second_attend rescue nil}",
                           :start_date => Time.now)
    @tagging.save
  end
  
  def create_auto_contact(v)
    @contact_type = ContactType.find_by_name(v)
    @contact = Contact.new(:contact_type_id => @contact_type.id, :contactable_id => self.id, contactable_type: 'Person',
                           :created_by => "system",
                           :comments => "created by system for #{v} instance. Max Date: #{self.max_date}, Attend Count: #{self.attend_count}, Second Attend Date: #{second_attend rescue nil}")
    @contact.save
  end
  
  
  def has_tag_in_last_six_days?(tag_name)
    taggings = self.taggings.last_six_days
    taggings.collect {|t| t.tag.name}.include?(tag_name)
  end
  
  def has_contact_in_last_six_days?(contact_type_name)
    contacts = self.contacts.last_six_days
    contacts.collect {|c| c.contact_type.name}.include?(contact_type_name)
  end
  
  
  def self.status_not(status)
    people = Arel::Table.new(:people)
    where(people[:attendance_status].not_eq(status))
  end
  
  def attendances_for_group_id(group_id)
    self.attendances.where('meetings.group_id = ?', group_id).joins(:meeting => [:instance => :event])
  end
  
  def attendances_for_group(group_name)
    self.attendances.where('groups.name LIKE ?', group_name).joins(:meeting => [:group, :instance => :event])
  end
  
  # Used to set attend count. Number of unique events attended. Double dipping counts as one attend.
  def attended_events
    Event.where('attendances.person_id = ?', self.id).includes(:instances => [:meetings => :attendances]).references(:instances)
  end
    
  def full_name
    first_name + ' ' + last_name
  end
  
  def id_and_full_name
    id.to_s + ' ' + full_name
  end
  
  def last_first_name
    self.last_name + ', ' + self.first_name
  end
  
  # TODO: This should find the first mobile number.
  def mobile_number
    phones.mobile.try(:first).try(:number)
  end
  
  def best_number
    self.mobile_number ? mobile_number : self.phones.present? ? self.phones.first.number : self.household.phones.present? ? self.household.best_number : 'no phone'
  end
  
  def no_mobile_number?
    phones.mobile.empty? ? true : false
  end
  
  def primary_email
    emails.primary.try(:first).try(:email)
  end
  
  def any_email
    emails.try(:first).try(:email)
  end
  
  def best_email
    self.primary_email ? primary_email : self.any_email ? self.any_email : self.household.first_email
  end
  
  def first_email
    self.emails.present? ? self.emails.first.email : 'no email'
  end
  
  def no_email?
    self.emails.empty? ? true : false
  end
  
  def default_group_name
    self.default_group ? self.default_group.name : "none assigned"
  end
  
  def discrete_birthdate
   if self.birthdate.blank?
     "nof"
   else
     birthdate.strftime('%m/%d')
   end
  end
  
  def family_name
    self.last_name == self.household.name ? self.first_name : self.first_name + ' ' + self.last_name
  end
    
  def full_name_with_id
    self.full_name + ' (#'+ self.id.to_s + ')'
  end
  
  def sort_order
	  if self.household_position == "Primary Contact"
	    "1" + "     " + self.birthdate_to_s
    elsif self.household_position == "Spouse"
      "2" + "     " + self.birthdate_to_s
    elsif self.household_position == "Dependent"
      "3" + "     " + self.birthdate_to_s
    elsif self.household_position == "Relative"
      "4" + "     " + self.birthdate_to_s
    elsif self.household_position == "Friend"
      "5" + "     " + self.birthdate_to_s
    else
      "6" + "     " + self.birthdate_to_s
    end
	end
	
	def to_vcard
	 #TODO: Finish this!
	 begin
	 card = Vpim::Vcard::Maker.make2 do |maker|
	   # make a vCard
	   maker.add_name do |name|
       name.given = first_name
       name.family = last_name
     end
     
     maker.add_addr do |addr|
       addr.location = 'home'
       addr.street = household.address1
       addr.locality = household.city
       addr.region = household.state
       addr.postalcode = household.zip.to_s
     end
     
     phones.each do |phone|
       maker.add_tel(phone.number) do |tel|
         tel.location = phone.comm_type.name
       end
     end
     
     household.phones.each do |phone|
       maker.add_tel(phone.number) do |tel|
         tel.location = phone.comm_type.name
       end
     end
     
     emails.each do |email|
       maker.add_email(email.email) do |m|
         m.location = email.comm_type.name
       end
     end
     
     household.emails.each do |email|
       maker.add_email(email.email) do |m|
         m.location = email.comm_type.name
       end
     end
     
     maker.birthday = birthdate if birthdate
     
     if self.image?
       maker.add_photo do |photo|
         photo.image = open(self.image_url).read # a fake string, real data is too large :-)"
         photo.type = 'jpeg'
       end
     end
     
   end
   card.to_s
   rescue
   end
	end
	
	def birthdate_to_s
	  self.birthdate.blank? ? '' : self.birthdate.to_s(:db)
	end
	
	def checked_into_instance?(instance)
	  instance.uniq_people.collect {|p| p.id}.include?(self.id)
	end
	
	def checkin(options={})
    meeting = Meeting.where(instance_id: options[:instance_id] || Instance.current, group_id: options[:group_id] || self.default_group_id).first
    if meeting
      attendance = Attendance.new(person_id: self.id, meeting_id: meeting.id, checkin_time: Time.now, checkout_time: options[:checkout_time] || nil)
      attendance.save!
      attendance
      # true
    else
      attendance = Attendance.new(person_id: self.id)
      attendance.errors.add(:base, "There is no meeting for this person's default group")
      attendance
    end
    rescue ActiveRecord::RecordInvalid => invalid
      logger.info "Invalid Attendance Record: #{invalid.record.inspect}"
      invalid.record
	end
	
	def merge_phones_into(keeper)
	  keeper_numbers = keeper.phones.collect {|p| p.number}
	  self.phones.each do |phone|
	    if keeper_numbers.include?(phone.number)
	      phone.destroy
      else
        phone.update_attribute(:phonable_id, keeper.id)
      end
    end
	end
	
	def merge_emails_into(keeper)
	  keeper_emails = keeper.emails {|m| m.email}
	  self.emails.each do |email|
	    if keeper_emails.include?(email.email)
	      email.destroy
      else
        email.update_attribute(:emailable_id, keeper.id)
      end
    end
	end
	
	def merge_attendances_into(keeper)
	  keeper_meetings = keeper.attendances.collect {|a| a.meeting_id}
	  self.attendances.each do |attendance|
	    if keeper_meetings.include?(attendance.meeting_id)
	      attendance.destroy
      else
        attendance.update_attribute(:person_id, keeper.id)
      end
    end
	end
	
	def merge_enrollments_into(keeper)
	  keeper_groups = keeper.enrollments.collect {|n| n.group_id}
	  self.enrollments.each do |enrollment|
	    if keeper_groups.include?(enrollment.group_id)
	      enrollment.destroy
      else
        enrollment.update_attribute(:person_id, keeper.id)
      end
    end
	end
	
	def merge_taggings_into(keeper)
	  self.taggings.each do |t|
	    t.update_attribute(:person_id, keeper.id)
    end
	end
	
	def merge_attendance_trackers_into(keeper)
	  keeper_trackers = keeper.attendance_trackers.collect {|a| a.group_id}
	  self.attendance_trackers.each do |t|
	    if keeper_trackers.include?(t.group_id)
	      t.destroy
      else
        t.update_attribute(:person_id, keeper.id)
      end
    end
	end
	
	def merge_contacts_into(keeper)
	  self.contacts.each do |c|
	    c.update_attribute(:contactable_id, keeper.id)
    end
	end
	
	def merge_contributions_into(keeper)
	  self.contributions.each do |o|
	    o.update_attribute(:contributable_id, keeper.id)
    end
	end
	
	def promote!(from_group, to_group)
	  enrollment = self.enrollments.for_group_id(from_group.id).first
	  enrollment.unenroll!
	  # if person already has an enrollment for the new group, make it active
	  if self.group_ids.include?(to_group.id)
	    self.enrollments.for_group_id(to_group.id).first.update_attribute(:end_time, nil)
	  # otherwise, enroll them into the new group
    else
      self.enroll!(to_group)
	  end
	  self.update_attribute(:default_group_id, to_group.id)
	end
		
	def search_order
    self.last_name + "               "[0..15-self.last_name.length] + self.first_name
  end
  
	# Unique events present for. Double dipping counts as one attend.
	def set_attend_count
    self.update_attribute(:attend_count, self.attended_events.size)
  end
  
  def set_attendance_status
    statuses = Person::STATUSES
    statuses.delete('Deceased')
    statuses.each do |status|
      people = Person.send(status.downcase.pluralize.to_sym)
      if people.collect {|p| p.id}.include?(self.id) && self.attendance_status != status
        self.change_status(status)
        break
      end
    end
  end
  
  def set_enrolled
    update_attribute(:enrolled, self.enrollments.current.empty? ? false : true)
  end
  
  def set_facebook_uid
    self.facebook_uid = self.facebook_url.split('/').last.split('?').first if self.facebook_url.present?
  end
  
	def set_first_attend
	  if min_date.blank?
  	  a = attendances.joins(:meeting => {:instance => :event}).order('events.date ASC').first
  	  if a
  	    update_attribute(:min_date, a.date.to_date.to_s(:db))
      end
    end
	end
	
	def update_first_attend
	  a = attendances.joins(:meeting => {:instance => :event}).order('events.date ASC').first
	  update_attribute(:min_date, a ? a.date.to_date.to_s(:db) : nil)
	end
	
	def set_recent_attend
	  a = attendances.joins(:meeting => {:instance => :event}).order('events.date DESC').first
	  update_attribute(:max_date, a ? a.date.to_date.to_s(:db) : nil)
	end
	
	def set_second_attend
	  a = attended_events.order('events.date ASC').to_a[-2]
	  self.update_attribute(:second_attend, a.date.to_time.to_s(:db)) if a
	end
	
	def set_max_worship_date
	  a = attendances_for_group('Adult Worship').order('events.date DESC').first
	  update_attribute(:max_worship_date, a ? a.date.to_s(:db) : nil)
	end
	
	def set_worship_attends
	  update_attribute(:worship_attends, self.attendances_for_group('Adult Worship').size)
	end
		
	def enroll_in_group_id(group_id)
    @enrollment = Enrollment.new(:person_id => self.id, :group_id => group_id)
    @enrollment.save
  end
  
  def enroll!(group)
    enrollment = Enrollment.new
    enrollment.group = group
    enrollment.person = self
    if enrollment.save
      true
    else
      enrollment
    end
  end
  
  def enrolled_in_group?(group)
    self.groups.collect {|g| g.id}.include?(group.id)
  end
  
  def update_enrollment_for_group_id(group_id)
    group = Group.find(group_id)
    if attendances_for_group_id(group.id).empty?
      unenroll_from_group_id(group.id)
    end
  end
  
  def change_status(status)
    self.update_attribute(:attendance_status, status)
  end
  
  def unenroll_from_group_id(group_id)
    group = Group.find(group_id)
    self.groups.delete(group)
  end
  
  def facebook_object
    uri = URI.parse("http://graph.facebook.com/#{facebook_uid}?fields=picture.type(large)")
    data = open(uri).read
    ActiveSupport::JSON.decode(data)
  rescue OpenURI::HTTPError => ex
    logger.info "rescuing error: #{ex}"
    false
  end
  
  def facebook_image_url
    facebook_object["picture"]["data"]["url"]
  end
  
  def get_facebook_profile_pic
    if facebook_uid.blank? or facebook_object == false
      logger.info "uid blank or facebook false - returning false"
      false
    else
      pic = open("person_#{self.id}_facebook_pic.jpg", "wb") do |file|
        file << open(facebook_image_url).read
      end
      self.update_attribute(:image, File.open(pic))
    end
  end
  
  def has_allergies?
    self.allergies.blank? ? false : true
  end
  
  def self.to_csv(people)
    columns = %w[FirstName LastName Address1 Address2 City State Zip Phone Email BirthDate CreatedBy UpdatedBy]
    
    CSV.generate do |csv|
      csv << columns
      people.each do |p|
        csv << p.attributes_for_export
      end
    end
  end
  
  def attributes_for_export
    attributes = []
    attributes << self.first_name
    attributes << self.last_name
    attributes << self.household.address1
    attributes << self.household.address2
    attributes << self.household.city
    attributes << self.household.state
    attributes << self.household.zip
    attributes << self.best_number
    attributes << self.first_email
    attributes << self.birthdate
    attributes << self.created_by
    attributes << self.updated_by
  end
  
  def self.to_households_csv(people)
    columns = %w[Name Address1 Address2 City State Zip Phone Email CreatedBy UpdatedBy]
    
    CSV.generate do |csv|
      csv << columns
      people.each do |p|
        csv << p.household.attributes_for_export
      end
    end
  end  
  
  private
  
  def set_last_name
    self.last_name = self.household.name if self.last_name.blank?
  end
  
  def set_initial_status
    self.attendance_status = "Guest"
  end
        
end
