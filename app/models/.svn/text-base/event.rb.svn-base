class Event < ActiveRecord::Base
  has_many :instances, :conditions => ['instances.deleted_at IS NULL'], :dependent => :destroy
  has_many :meetings, :through => :instances, :conditions => ['meetings.deleted_at IS NULL']
  belongs_to :event_type
  has_many :attendances, :through => :meetings
  has_many :staff_attendances, :through => :meetings, :conditions => {:checkin_type_id => 2 }
  has_many :participant_attendances, :through => :meetings, :conditions => {:checkin_type_id => 1 }
  
  acts_as_paranoid
  
  validates_uniqueness_of :date, :scope => [:event_type_id], :message => 'There is already an event of this type on this date.'
  validates_presence_of :date
  
  after_create :auto_create_instances
  
  def auto_create_instances
    self.event_type.auto_instance_types.each do |i|
      @instance = Instance.new(:event_id => self.id,
                               :instance_type_id => i.instance_type_id)
      @instance.save
    end
  end
  
  def self.find_available
    find(:all, :conditions => ['date BETWEEN DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY) AND DATE_ADD(CURRENT_DATE, INTERVAL +3 DAY)'])
  end
  
  def display_name
    self.formatted_date.to_s + ' ' + self.event_type.name
  end
  
  def formatted_date
    unless self.date.blank?
     date.strftime('%m/%d/%Y')
   end
  end
  
  def head_count
    Event.find(:first, :select => ['sum(meetings.total_count) as head_count'],
               :joins => ['INNER JOIN instances ON instances.event_id = events.id
                           INNER JOIN meetings ON meetings.instance_id = instances.id'],
               :conditions => ['events.id = ?', self.id])
  end
  
  def self.create_in_mass(number_of,event_type_id,weekday,beginning_date)
      ending_date = (beginning_date.to_time + number_of.weeks).to_date
      beginning_date.step(ending_date,7) do |date|
          @event = Event.new(:date => date, :event_type_id => event_type_id)
          @event.save if date.wday == weekday
      end
      @message = "Done"
  end
  
  def self.find_by_ez_where(range_result)
    sql_conditions = []
    unless range_result == "All"
      if range_result == "This Month"
        start_range = Time.now.beginning_of_month
        end_range = Time.now.end_of_month
      elsif range_result == "Last 30 Days"
        start_range = (Time.now - 30.days)
        end_range = Time.now
      elsif range_result == "This Week"
          start_range = (Time.now.beginning_of_week - 1.day)
          end_range = Time.now.end_of_week
      elsif range_result == "Last 7 Days"
          start_range = (Time.now - 7.days)
          end_range = Time.now
      elsif range_result == "Last 14 Days"
          start_range = (Time.now - 14.days)
          end_range = Time.now
      elsif range_result == "Year To Date"
            start_range = (Time.now.beginning_of_year)
            end_range = Time.now
      end
      range_condition = Caboose::EZ::Condition.new :events do
        date <=> (start_range..end_range)
      end
      sql_conditions << range_condition
    end
    
    combined_cond = Caboose::EZ::Condition.new
        sql_conditions.each do |item|
          combined_cond << item
        end
        
    find(:all, :conditions => combined_cond.to_sql, :order => ["date DESC"])
    
  end
  
  def available_instance_types
      used_types = self.instances.collect {|i| i.instance_type}
      all_types = InstanceType.find(:all)
      available_types = all_types - used_types
  end
  
  
  
end
