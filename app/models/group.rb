class Group < ActiveRecord::Base
  

  
  has_many :meetings
  belongs_to :default_room, :class_name => "Room", :foreign_key => "default_room_id"
  has_many :enrollments, :dependent => :destroy, :include => :person, :conditions => ['people.household_position <> "Deceased"']
  has_many :current_enrollments, :class_name => "Enrollment", :foreign_key => "group_id", :conditions => ['(enrollments.start_time <= ?) AND (enrollments.end_time >= ? OR enrollments.end_time IS NULL)', Time.now.to_s(:db), Time.now.to_s(:db)]
  has_many :past_enrollments, :class_name => "Enrollment", :foreign_key => "group_id", :conditions => ['enrollments.end_time < ?', Time.now.to_s(:db)]
  
  has_many :people, :through => :enrollments, :conditions => ['(people.household_position <> "Deceased")
                                                                AND (enrollments.start_time <= ?) AND (enrollments.end_time >= ? OR enrollments.end_time IS NULL)', Time.now.to_s(:db), Time.now.to_s(:db)]
  has_many :service_links
  has_many :linked_teams, :through => :service_links, :source => :team
  has_many :involvements, :through => :linked_teams
  has_many :potential_staff, :through => :involvements, :source => :person
  belongs_to :updater, :class_name => "User", :foreign_key => "updated_by"
  belongs_to :responsible_person, :class_name => "User", :foreign_key => "responsible_person_id"
  belongs_to :responsible_staff, :class_name => "User", :foreign_key => "staff_person_responsible_id"
  belongs_to :meets_at_household, :class_name => "Household", :foreign_key => "meets_at_household_id"
  has_and_belongs_to_many :web_categories, :join_table => "groups_web_categories", :order => ['name ASC']
  #small group choices...
  belongs_to :special_requirement, :class_name => "GroupChoice", :foreign_key => "special_requirement_id"
  belongs_to :curriculum_choice, :class_name => "GroupChoice", :foreign_key => "curriculum_choice_id"
  belongs_to :curriculum_cost, :class_name => "GroupChoice", :foreign_key => "curriculum_cost_id"
  belongs_to :small_group_leader, :class_name => "Person", :foreign_key => "small_group_leader_id"
  belongs_to :attendance_requirement, :class_name => "GroupChoice", :foreign_key => "attendance_requirement_id"
  belongs_to :is_childcare_provided, :class_name => "GroupChoice", :foreign_key => "is_childcare_provided_id"
  belongs_to :meeting_cadence, :class_name => "GroupChoice", :foreign_key => "meeting_cadence_id"
  belongs_to :meeting_place, :class_name => "GroupChoice", :foreign_key => "meeting_place_id"
  belongs_to :leader_name_for_printing, :class_name => "GroupChoice", :foreign_key => "leader_name_for_printing_id"
  
  MEETING_DAYS = [ "Sundays", "Mondays", "Tuesdays", "Wednesdays", "Thursdays", "Fridays", "Saturdays", "Various" ]
  MEETING_DAYS_WITH_ANY = [ "Any", "Sundays", "Mondays", "Tuesdays", "Wednesdays", "Thursdays", "Fridays", "Saturdays" ]
  SCOPE_CHOICES = ["Live", "Archived", "All"]
  ENROLLMENT_CHOICES = ["All", "Current", "Past"]
  
  
  validates_uniqueness_of :name
  validates_presence_of :tree_id
  #validates_presence_of :default_room_id
  
  acts_as_nested_set :scope => :tree_id
  

  def validate
      errors.add_to_base("You can't archive a group that has children.") if self.has_children? && ! self.archived_on.nil?
  end
  
  def self.new_tree_id
    find(:all).collect {|g| g.tree_id}.max + 1
  end
  
  def self.set_scope(user_id,scope)
    u = User.find(user_id)
    case scope
    when "Live"
        new_value = "archived_on IS NULL"
    when "Archived"
        new_value = "archived_on IS NOT NULL"
    when "All"
        new_value = "1 = 1"
    end
    u.update_attribute(:group_scope, new_value)
  end
  
  def search_order
    self.name + "               "[0..15-self.name.length]
  end
  
  def more_level
    self.level * 2
  end
  
  def self.checkin_groups
    find(:all, :conditions => ['checkin_group = ?', 1])
  end
  
  def url_for
     	"/groups/show/#{id}"
	end
	
   def has_children?(options=nil)
	   if self.all_children(options || nil).length > 0
	     true
       else
         false
       end
   end
   
   
   def self.all_leaves(options=nil)
    Group.find(:all).reject {|g| g.has_children?(options || nil) or g.root?}.sort_by(&:name)
   end
	
	def has_enrollments?
	  if self.enrollments.length > 0
	    true
    else
      false
    end
	end
	
	def archived?
	   if self.archived_on.nil?
	       false
	   else
	       self.archived_on < Time.now or nil ? true : false
       end
	end
	
	def special_requirement_value
	 unless self.special_requirement.nil?
	 @result = self.special_requirement.name ||= ''
	 @result
   else
     @result = ''
   end
	end
	
	def curriculum_choice_value
	  unless self.curriculum_choice.nil?
	   @result = self.curriculum_choice.name ||= ''
  	 @result
    else
      @result = ''
    end
	end
	
	def curriculum_cost_value
	  unless self.curriculum_cost.nil?
	 @result = self.curriculum_cost.name ||= ''
	 @result
    else
      @result = ''
    end
	end
	
	def attendance_requirement_value
	  unless self.attendance_requirement.nil?
	 @result = self.attendance_requirement.name ||= ''
	 @result
    else
      @result = ''
    end
	end
	
	def is_childcare_provided_value
	  unless self.is_childcare_provided.nil?
	 @result = self.is_childcare_provided.name ||= ''
	 @result
    else
      @result = ''
    end
	end
	
	def meeting_cadence_value
	  unless self.meeting_cadence.nil?
	 @result = self.meeting_cadence.name ||= ''
	 @result
    else
      @result = ''
    end
	end
	
	def leader_name_for_printing_value
	  unless self.leader_name_for_printing.nil?
	 @result = self.leader_name_for_printing.name ||= ''
	 @result
    else
      @result = ''
    end
	end
	
	def meeting_place_value
	  unless self.meeting_place.nil?
	 @result = self.meeting_place.name ||= ''
	 @result
    else
      @result = ''
    end
	end
	
	def kids
	 Group.find(:all, :conditions => {:parent_id => self.id})
	end
	
	def self.checkin_groups
	  Group.find(:all, :conditions => {:checkin_group => true}, :order => ['name ASC'])
	end
	
	def self.web_groups(meets_on,category_ids)
	 Group.find(:all, :select => ['groups.name, groups.id, show_on_web, meets_on, blurb'],
	            :joins => ['LEFT OUTER JOIN groups_web_categories ON groups_web_categories.group_id = groups.id
	                        LEFT OUTER JOIN web_categories ON web_categories.id = groups_web_categories.web_category_id'],
	            :conditions => ['(meets_on LIKE ?) AND (show_on_web = "1") AND (web_categories.id IN (?))', meets_on,category_ids],
	            :order => ['groups.name ASC'],
	            :group => ['groups.id'])
	end
	
	def self.web_zip_codes
	 Group.find(:all, :select => ['DISTINCT households.zip'],
	            :joins => ['JOIN households ON groups.meets_at_household_id = households.id'],
	            :conditions => ['show_on_web = "1"'],
	            :order => ['zip ASC'])
	end
	
	def is_a_small_group?
	  return false if self.has_children?
	  self.ancestors.collect {|g| g.name}.include?("Small Groups") ? true : false
	end
	
	def meetings_for_range(named_range)
	 range_cond = Tool.range_condition(named_range,"events","date")
	 self.meetings.find(:all, :conditions => range_cond ? range_cond.to_sql : "1=1",
	                    :include => [:instance => [:event ]])
	end
		
end
