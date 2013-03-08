class Person < ActiveRecord::Base
  belongs_to :household
  belongs_to :default_group, :class_name => "Group", :foreign_key => "default_group_id"
  
  has_many :phones, :as => :phonable
  has_many :emails, :as => :emailable
  
  validates :first_name, :gender, :household_id, :default_group_id, presence: true
  
  mount_uploader :image, ImageUploader
  
  before_save :set_last_name
  
  POSITIONS = [ "Primary Contact", "Spouse", "Dependent", "Friend", "Relative", "Deceased" ]
  GENDERS = ["Female", "Male"]
  FILTER_VALUES = ["All", "Recent Attenders", "Newcomers", "Active Attenders"]
  
  def set_last_name
    self.last_name = self.household.name if self.last_name.blank?
  end
  
  def full_name
    first_name + ' ' + last_name
  end
  
  def default_group_name
    self.default_group ? self.default_group.name : "none assigned"
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
	
	def checkin(options={})
    meeting = Meeting.where(instance_id: options[:instance_id] || Instance.current, group_id: options[:group_id] || self.default_group_id).first
    if meeting
      attendance = Attendance.new(person_id: self.id, meeting_id: meeting.id, checkin_time: Time.now)
      attendance.save
      true
    else
      false
    end
	end
		  
end
