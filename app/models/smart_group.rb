class SmartGroup < ActiveRecord::Base
  has_many :smart_group_rules, :dependent => :destroy
  
  validates_presence_of :name, :message => "You give this smart group a name."
  #validates_associated :smart_group_rules
  validate :must_have_at_least_one_rule
  
  def must_have_at_least_one_rule
      errors.add_to_base("You must have at least one rule.") if self.smart_group_rules.length.zero?
  end
  
  def check_for_at_least_one_rule
    errors.add("blah") unless self.smart_group_rules.size > 0
  end
  
  def combined_conditions
    combined_cond = EZ::Where::Condition.new
    self.smart_group_rules.each do |s|
      combined_cond << s.sql_conditions
    end
    combined_cond.to_sql
  end
  
  def found_people
    #having = "HAVING (MAX(events.date) < '2007-12-31')"
    combined_cond = EZ::Where::Condition.new
    self.smart_group_rules.each do |s|
      combined_cond << s.sql_conditions
    end
    
    @people = Person.find(:all,
                :select => ['people.id, people.household_id, people.gender, people.household_position, people.first_name, people.last_name, people.birthdate, people.estimated_birthdate,
                             tags.name, groups.name, people.attendance_status'],
                :joins => ["LEFT OUTER JOIN taggings ON (people.id = taggings.person_id)
                            LEFT OUTER JOIN tags ON (tags.id = taggings.tag_id)
                            LEFT OUTER JOIN enrollments ON (people.id = enrollments.person_id)
                            LEFT OUTER JOIN groups ON (groups.id = enrollments.group_id)
                            LEFT OUTER JOIN attendances ON attendances.person_id = people.id 
                            LEFT OUTER JOIN meetings ON meetings.id = attendances.meeting_id 
                            LEFT OUTER JOIN instances ON instances.id = meetings.instance_id 
                            LEFT OUTER JOIN events ON events.id = instances.event_id
                            LEFT OUTER JOIN attendance_trackers ON attendance_trackers.person_id = people.id
                            #{self.exclusive_tags_sql}"],
                :include => :household,
                :conditions => combined_cond.to_sql,
                :group => ['people.id'])
    @people
  end
  
  def found_households
      #having = "HAVING (MAX(events.date) < '2007-12-31')"
      combined_cond = EZ::Where::Condition.new
      self.smart_group_rules.each do |s|
        combined_cond << s.sql_conditions
      end

      @people = Person.find(:all,
                  :select => ['people.id, people.household_id, people.gender, people.household_position, people.first_name, people.last_name, people.birthdate, people.estimated_birthdate,
                               tags.name, groups.name, people.attendance_status, households.id'],
                  :joins => ["LEFT OUTER JOIN households ON (households.id = people.household_id)
                              LEFT OUTER JOIN taggings ON (people.id = taggings.person_id)
                              LEFT OUTER JOIN tags ON (tags.id = taggings.tag_id)
                              LEFT OUTER JOIN enrollments ON (people.id = enrollments.person_id)
                              LEFT OUTER JOIN groups ON (groups.id = enrollments.group_id)
                              LEFT OUTER JOIN attendances ON attendances.person_id = people.id 
                              LEFT OUTER JOIN meetings ON meetings.id = attendances.meeting_id 
                              LEFT OUTER JOIN instances ON instances.id = meetings.instance_id 
                              LEFT OUTER JOIN events ON events.id = instances.event_id
                              LEFT OUTER JOIN attendance_trackers ON attendance_trackers.person_id = people.id
                              #{self.exclusive_tags_sql}"],
                  :include => :household,
                  :conditions => combined_cond.to_sql,
                  :group => ['people.household_id'])
      @people
    end
    
    def exclusive_tags
      @result = []
      self.smart_group_rules.each {|r| @result << r.exclusive_tags}
      @result.compact.flatten
    end
    
    def exclusive_tags_sql # creates a SQL fragment for inner joins if AND tags exist or empty string otherwise
      @result = String.new
      if self.exclusive_tags.empty?
        @result = ""
      else
       self.exclusive_tags.each_with_index {|tag,index| @result << " INNER JOIN taggings taggings_#{index.to_s} ON taggings_#{index.to_s}.person_id = people.id INNER JOIN tags tags_#{index.to_s} ON (tags_#{index.to_s}.id = taggings_#{index.to_s}.tag_id AND tags_#{index.to_s}.name = '#{tag.to_s}') "}
     end
     # I can't figure out why this is returning an array... so, this bit inspects for array mambers and coverts them to one string fi found
     @result.empty? ? @result : @result[1..-1].join(" ")
   end
      
end


