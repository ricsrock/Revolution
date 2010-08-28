class SmartGroupRule < ActiveRecord::Base
  belongs_to :smart_group
  belongs_to :smart_group_property, :class_name => "SmartGroupProperty", :foreign_key => "property_id"
  belongs_to :operator, :class_name => "Operator", :foreign_key => "operator_id"
  
  validates_presence_of :property_id, :message => "You must select a property for each rule."
  #validates_presence_of :operator_id, :unless => Proc.new {|rule| rule.smart_group_property.operators.length < 1}
  validates_presence_of :content, :message => "You must provide content for each rule."
  #validates_uniqueness_of :property_id, :scope => :smart_group_id, :message => 'You can only use each property once per smart group' #one use of a property per smart group
  
  before_destroy :at_least_one_rule
  
  attr_accessor :extra
  
  def at_least_one_rule
    false if self.smart_group.smart_group_rules.size == 1
  end
  
  def sql_conditions
    case self.smart_group_property.short
    when "age"
        if self.operator.short === "between"
          #do between stuff...
          start_age = self.content.split[0].to_i
          end_age = self.content.split[2].to_i
          start_range = (Time.now - start_age.years).to_date.to_s(:db)
          end_range = (Time.now - end_age.years).to_date.to_s(:db)
        
          cond = EZ::Where::Condition.new do
            birthdate <=> (end_range..start_range)
          end
        elsif self.operator.short === "greater"
          # do older than stuff...
          # birthdate less than today minus number of years old requested
          start_date = (Time.now - self.content.to_i.years).to_date.to_s(:db)
          cond = EZ::Where::Condition.new do
            birthdate < start_date
          end
        elsif self.operator.short === "less"
          # do younger than stuff...
          # birthdate greater than today minus number of years old requested
          start_date = (Time.now - self.content.to_i.years).to_date.to_s(:db)
          cond = EZ::Where::Condition.new do
            birthdate > start_date
          end
        end
    
    when "recent_attend"
      #do most recent attend stuff
      if self.operator.short === "before"
        
        the_date = (Time.now - self.content.to_i.weeks).strftime('%Y-%m-%d')
        cond = EZ::Where::Condition.new :people do
            max_date < the_date
          end
      
      elsif self.operator.short === "after"
         the_date = (Time.now - self.content.to_i.weeks).strftime('%Y-%m-%d')
        cond = EZ::Where::Condition.new :people do
            max_date > the_date
          end
        
        elsif self.operator.short === "between"
          #do between stuff...
          start_date = self.content.split[0].to_i
          end_date = self.content.split[2].to_i
          if start_date == 0
              start_range = Time.now.strftime('%Y-%m-%d')
          else
              start_range = (Time.now - start_date.weeks).strftime('%Y-%m-%d')
          end
          end_range = (Time.now - end_date.weeks).strftime('%Y-%m-%d')

            cond = EZ::Where::Condition.new :people do
                max_date <=> (end_range..start_range)
              end
      end
      
    when "first_attend"
      #do most recent attend stuff
      if self.operator.short === "less_than"
        
        the_date = (Time.now - self.content.to_i.weeks).strftime('%Y-%m-%d')
        cond = EZ::Where::Condition.new :people do
            min_date < the_date
          end
      
      elsif self.operator.short === "more_than"
        the_date = (Time.now - self.content.to_i.weeks).strftime('%Y-%m-%d')
        cond = EZ::Where::Condition.new :people do
            min_date > the_date
          end
        
      elsif self.operator.short === "between"
        #do between stuff...
        start_date = self.content.split[0].to_i
        end_date = self.content.split[2].to_i
        start_range = (Time.now - start_date.weeks).strftime('%Y-%m-%d')
        end_range = (Time.now - end_date.weeks).strftime('%Y-%m-%d')
    
          cond = EZ::Where::Condition.new :people do
              min_date <=> (end_range..start_range)
            end 
      end
      
    when "total_attends"
      if self.operator.short == "greater"
        number = self.content.to_i
        cond = EZ::Where::Condition.new :people do
            attend_count > number
          end 
        
      elsif self.operator.short == "less"
        number = self.content.to_i
        cond = EZ::Where::Condition.new :people do
            attend_count < number
          end
      elsif self.operator.short == "exactly"
        number = self.content.to_i
        cond = EZ::Where::Condition.new :people do
            attend_count = number
          end
      elsif self.operator.short == "between"
        start_range = self.content.split[0].to_i
        end_range = self.content.split[2].to_i
        cond = EZ::Where::Condition.new :people do
            attend_count <=> (start_range..end_range)
          end
      end
    
    when "birthday"
      months_from_now = self.content.to_i
      cond = "MONTH(birthdate) = #{(Time.now.month + months_from_now)}"
    when "gender"
      result = self.content
      cond = EZ::Where::Condition.new do
        gender =~ result
      end
    when "attendance_status"
        result = self.content.split(',')
        cond = EZ::Where::Condition.new :people do
            any do
                attendance_status === result
            end
        end
    when "household_position"
      #do household_position stuff: parse comma seperated values and ask any for each...
      #first: get the split values figured out: how many do we have?
      things_to_find = self.content.split(',')
      cond = EZ::Where::Condition.new do
        any do
          household_position === things_to_find #need an array of items in value field... 
        end
      end 
    
    when "have_tag"
      tags_to_find = self.content.split(',')
      cond = EZ::Where::Condition.new :tags do
        any do
          name === tags_to_find
        end
      end
            
  when "not_have_tag"
    tags = self.content.split(',')
    cond = ["(people.id NOT IN (select people.id from people join taggings on people.id = taggings.person_id join tags on tags.id = taggings.tag_id where tags.name IN (?)))", tags]
    
    when "have_group"
        groups_to_find = self.content.split(',')
        cond = EZ::Where::Condition.new :groups do
            any do
                name === groups_to_find
            end
        end
        
    when "zip"
        zips_to_find = self.content.split(',')
        cond = EZ::Where::Condition.new :households do
            any do
                zip === zips_to_find
            end
        end
        
    when "created_date"
        if self.operator.short === "before"

            the_date = (Time.now - self.content.to_i.weeks).strftime('%Y-%m-%d')
            cond = EZ::Where::Condition.new :people do
                created_at < the_date
              end

          elsif self.operator.short === "after"
             the_date = (Time.now - self.content.to_i.weeks).strftime('%Y-%m-%d')
            cond = EZ::Where::Condition.new :people do
                created_at > the_date
              end

            elsif self.operator.short === "between"
              #do between stuff...
              start_date = self.content.split[0].to_i
              end_date = self.content.split[2].to_i
              start_range = (Time.now - start_date.weeks).strftime('%Y-%m-%d')
              end_range = (Time.now - end_date.weeks).strftime('%Y-%m-%d')

                cond = EZ::Where::Condition.new :people do
                    created_at <=> (end_range..start_range)
                  end
          end
        
    when "contr_count"
      if self.operator.short == "greater"
        number = self.content.to_i
        cond = EZ::Where::Condition.new :people do
            contr_count > number
          end 
        
      elsif self.operator.short == "less"
        number = self.content.to_i
        cond = EZ::Where::Condition.new :people do
            contr_count < number
          end
      elsif self.operator.short == "exactly"
        number = self.content.to_i
        cond = EZ::Where::Condition.new :people do
            contr_count == number
          end
      elsif self.operator.short == "between"
        start_range = self.content.split[0].to_i
        end_range = self.content.split[2].to_i
        cond = EZ::Where::Condition.new :people do
            contr_count <=> (start_range..end_range)
        end
      end
      
    when "recent_contr"
      if self.operator.short === "before"
        
        the_date = (Time.now - self.content.to_i.weeks)
        cond = EZ::Where::Condition.new :people do
            recent_contr < the_date
        end
      
      elsif self.operator.short === "after"
         the_date = (Time.now - self.content.to_i.weeks)
        cond = EZ::Where::Condition.new :people do
            recent_contr > the_date
        end
        
        elsif self.operator.short === "between"
          #do between stuff...
          start_date = self.content.split[0].to_i
          end_date = self.content.split[2].to_i
          if start_date == 0
              start_range = Time.now
          else
              start_range = (Time.now - start_date.weeks)
          end
          end_range = (Time.now - end_date.weeks)

            cond = EZ::Where::Condition.new :people do
                recent_contr <=> (end_range..start_range)
            end
        end
      
    when "recent_group_attend"
      if self.operator.short === "before"
        the_date = (Time.now - self.content.split(",")[0].to_i.weeks)
        the_group_id = self.group_id
        cond = EZ::Where::Condition.new :attendance_trackers do
            most_recent_attend < the_date
            group_id == the_group_id
        end
        
      elsif self.operator.short === "after"
        the_date = (Time.now - self.content.split(",")[0].to_i.weeks)
        the_group_id = self.group_id
        cond = EZ::Where::Condition.new :attendance_trackers do
            most_recent_attend > the_date
            group_id == the_group_id
        end
        
      elsif self.operator.short === "between"
        start_date = self.content.split(",")[0].split[0].to_i
        end_date = self.content.split(",")[0].split[2].to_i
        if start_date == 0
            start_range = Time.now
        else
            start_range = (Time.now - start_date.weeks)
        end
        end_range = (Time.now - end_date.weeks)
        the_group_id = self.group_id
        cond = EZ::Where::Condition.new :attendance_trackers do
            most_recent_attend <=> (end_range..start_range)
            group_id == the_group_id
        end
      end
        
      when "first_group_attend"
        if self.operator.short === "before"
          the_date = (Time.now - self.content.split(",")[0].to_i.weeks)
          the_group_id = self.group_id
          cond = EZ::Where::Condition.new :attendance_trackers do
              most_recent_attend < the_date
              group_id == the_group_id
          end

        elsif self.operator.short === "after"
          the_date = (Time.now - self.content.split(",")[0].to_i.weeks)
          the_group_id = self.group_id
          cond = EZ::Where::Condition.new :attendance_trackers do
              most_recent_attend > the_date
              group_id == the_group_id
          end

        elsif self.operator.short === "between"
          start_date = self.content.split(",")[0].split[0].to_i
          end_date = self.content.split(",")[0].split[2].to_i
          if start_date == 0
              start_range = Time.now
          else
              start_range = (Time.now - start_date.weeks)
          end
          end_range = (Time.now - end_date.weeks)
          the_group_id = self.group_id
          cond = EZ::Where::Condition.new :attendance_trackers do
              most_recent_attend <=> (end_range..start_range)
              group_id == the_group_id
          end
      end
      
      when "group_count"
        if self.operator.short == "greater"
          number = self.content.split(",")[0].to_i
          the_group_id = self.group_id
          cond = EZ::Where::Condition.new :attendance_trackers do
              count > number
              group_id == the_group_id
            end 
 
        elsif self.operator.short == "less"
          number = self.content.split(",")[0].to_i
          the_group_id = self.group_id
          cond = EZ::Where::Condition.new :attendance_trackers do
              count < number
              group_id == the_group_id
            end
        elsif self.operator.short.to_s == "exactly"
          number = self.content.split(",")[0].to_i
          the_group_id = self.group_id.to_i
          cond = EZ::Where::Condition.new :attendance_trackers do
              count == number
              group_id == the_group_id
            end
        elsif self.operator.short == "between"
          start_range = self.content.split[0].to_i
          end_range = self.content.split[2].to_i
          the_group_id = self.group_id.to_i
          cond = EZ::Where::Condition.new :attendance_trackers do
              count <=> (start_range..end_range)
              group_id == the_group_id
          end
        end
     
     when "mapped"
       if self.content == "true"
         #cond = EZ::Where::Condition.new :households do
           cond = 'households.lng IS NOT NULL AND households.lat IS NOT NULL'
         #end
       elsif self.content == "false"
        # cond = EZ::Where::Condition.new :households do
            cond = 'households.lng IS NULL AND households.lat IS NULL'
         # end
       end
   
      when "picture"
        if self.content == "true"
          cond = 'people.has_a_picture = 1'
        elsif self.content == "false"
          cond = 'people.has_a_picture = 0'
        end

      when "involved"
        if self.content == "true"
          cond = 'people.involved = 1'
        elsif self.content == "false"
          cond = 'people.involved = 0'
        end

      when "enrolled"
        if self.content == "true"
          cond = 'people.enrolled = 1'
        elsif self.content == "false"
          cond = 'people.enrolled = 0'
        end

      when "connected"
        if self.content == "true"
          cond = 'people.connected = 1'
        elsif self.content == "false"
          cond = 'people.connected = 0'
        end

     else
       nil
    end
  end
   
              
  def exclusive_tags
    case self.smart_group_property.short
    when "exclusive_tags"
      self.content.split(",").collect {|item| item.strip}
    else
      nil
    end
  end
  
  def not_have_tags
    case self.smart_group_property.short
    when "not_have_tag"
      self.content.split(",").collect {|i| i.strip}
    else
      nil
    end
  end
  
  def prose
    unless self.group_rule?
      prose = ''
      prose << self.smart_group_property.prose
      prose << ' ' + self.operator.prose unless self.operator.nil?
      prose << ' ' + self.content + '<br>'
      prose
    else
      prose = ''
      prose << self.smart_group_property.prose
      prose << ' ' + self.group_name + ' was '
      prose << self.operator.prose unless self.operator.nil?
      prose << ' ' + self.content.split(",")[0].strip + '<br>'
    end
  end
  
  def group_rule?
      if self.content.split(",").length == 2 && self.content.split(",")[1].include?("(group")
        true
      else
        false
      end
  end
  
  def group_id
    if self.group_rule?
      self.content.split(",")[1].gsub(/[()groupid]/,'').strip
    else
      nil
    end
  end
  
  def group_name
    if self.group_rule?
      Group.find(self.group_id).name
    else
      nil
    end
  end
  
  
end
