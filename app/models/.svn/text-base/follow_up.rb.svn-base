class FollowUp < ActiveRecord::Base
  belongs_to :contact, :class_name => "Contact", :foreign_key => "contact_id"
  belongs_to :follow_up_type, :class_name => "FollowUpType", :foreign_key => "follow_up_type_id"
  
  
  def self.find_by_ez_where(range_result,type_result,attribution,user_result,contact_type_result)
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
      range_condition = Caboose::EZ::Condition.new :follow_ups do
        created_at <=> (start_range..end_range)
      end
      sql_conditions << range_condition
    end
    
    unless type_result == ""
        type_id = type_result.to_i
        type_condition = Caboose::EZ::Condition.new :follow_ups do
            follow_up_type_id == type_id
        end
        sql_conditions << type_condition
    end
    
    unless attribution == ""
        attribution_cond = Caboose::EZ::Condition.new :contacts do
            stamp =~ attribution + '%'
        end
        sql_conditions << attribution_cond
    end
    
    unless user_result == ""
        user = User.find(:all, :conditions => ["login LIKE ?", user_result])
        user_cond = Caboose::EZ::Condition.new :contacts do
            responsible_user_id == user
        end
        sql_conditions << user_cond
    end
    
    unless contact_type_result == ""
        contact_type_cond = ["contacts.contact_type_id = ?", contact_type_result]
        sql_conditions << contact_type_cond
    end
    
    combined_cond = Caboose::EZ::Condition.new
    sql_conditions.each do |item|
      combined_cond << item
    end
    
    find(:all, :conditions => combined_cond.to_sql,
               :include => [:contact],
               :order => ['follow_ups.created_at'])
    
  end
  
  def attribution
    self.contact.stamp
  end
  
end
