module NamedDateRanges
  
  RANGES = ["Next 14 Days", "Today", "Last 24 Hours",
            "This Week", "Last 7 Days", "Last Week",
            "Last Two Weeks", "Last 14 Days",
            "This Month", "Last Month", "Last 30 Days", "Last 4 Weeks", "Last 8 Weeks", "Last 12 Weeks",
            "This QTR", "Last 13 Weeks", "Last QTR",
            "Year To Date", "Last Year", "Last 12 Months", "Last 6 Months"]
  
  def do_range(range_name)
    case range_name
    when "Next 14 Days"
      next_14_days
    when "Today"
      today
    when "Last 24 Hours"
      last_24_hours
    when "Last Two Weeks"
      last_two_weeks
    when "Year To Date"
      year_to_date
    when "This Month"
      this_month
    when "Last Month"
      last_month
    when "Last 4 Weeks"
      last_4_weeks
    when "Last 8 Weeks"
      last_8_weeks
    when "Last 12 Weeks"
      last_12_weeks
    when "This QTR"
      this_quarter
    when "Last 13 Weeks"
      last_13_weeks
    when "Last QTR"
      last_quarter
    when "Last 14 Days"
      last_14_days
    when "Last Year"
      last_year
    when "This Week"
      this_week
    when "Last 7 Days"
      last_7_days
    when "Last Week"
      last_week
    when "Last 30 Days"
      last_30_days
    when "Last 12 Months"
      last_12_months
    when "Last 6 Months"
      last_6_months 
    end
  end
  
  class DateRange
    
    
    
    attr_accessor :conditions, :start_date, :end_date, :name
    
    def initialize(conditions={})
      self.conditions = conditions if conditions.is_a?(Hash)
    end
    
    def conditions=(values)
      values.each do |condition, value|
        value.delete_if { |v| v.blank? } if value.is_a?(Array)
        next if value.blank?
        send("#{condition}=", value)
      end
    end
    
    def conditions
      @conditions ||= {}
    end
      
  end #DateRange class
  
  def next_14_days
    DateRange.new(:start_date => Time.now,
                  :end_date => Time.now + 14.days,
                  :name => "Next 14 Days")
  end
  
  def today
    DateRange.new(:start_date => Time.now.beginning_of_day,
                  :end_date => Time.now,
                  :name => "Today")
  end
  
  def last_24_hours
    DateRange.new(:start_date => Time.now - 24.hours,
                  :end_date => Time.now,
                  :name => "Last 24 Hours")
  end
  
  
  def last_two_weeks
    DateRange.new(:start_date => (Time.now - 1.week).beginning_of_week,
                  :end_date => Time.now,
                  :name => "Last Two Weeks")
  end
  
  def year_to_date
    DateRange.new(:start_date => Time.now.beginning_of_year,
                  :end_date => Time.now,
                  :name => "Year To Date")
  end
  
  def last_year
    DateRange.new(:start_date => (Time.now - 1.year).beginning_of_year,
                  :end_date => (Time.now - 1.year).end_of_year,
                  :name => "Last Year")
  end
  
  
  def this_month
    DateRange.new(:start_date => Time.now.beginning_of_month,
                  :end_date => Time.now,
                  :name => "This Month")
  end
  
  def last_month
    DateRange.new(:start_date => (Time.now - 1.month).beginning_of_month,
                  :end_date => (Time.now - 1.month).end_of_month,
                  :name => "Last Month")
  end
  
  def last_4_weeks
    DateRange.new(:start_date => (Time.now - 3.weeks).beginning_of_week,
                  :end_date => Time.now,
                  :name => "Last 4 Weeks")
  end
  
  def last_8_weeks
    DateRange.new(:start_date => (Time.now - 7.weeks).beginning_of_week,
                  :end_date => Time.now,
                  :name => "Last 8 Weeks")
  end
  
  def last_12_weeks
    DateRange.new(:start_date => (Time.now - 11.weeks).beginning_of_week,
                  :end_date => Time.now,
                  :name => "Last 12 Weeks")
  end
  
  
  def this_quarter
    DateRange.new(:start_date => Time.now.beginning_of_quarter,
                  :end_date => Time.now,
                  :name => "This QTR")
  end
  
  def last_13_weeks
    DateRange.new(:start_date => Time.now - 13.weeks,
                  :end_date => Time.now,
                  :name => "Last 13 Weeks")
  end
  
  def last_quarter
    DateRange.new(:start_date => (Time.now - 13.weeks).beginning_of_quarter,
                  :end_date => (Time.now - 13.weeks).end_of_quarter,
                  :name => "Last Quarter")
  end
  
  def last_14_days
    DateRange.new(:start_date => Time.now - 14.days,
                  :end_date => Time.now,
                  :name => "Last 14 Days")
  end
  
  def last_30_days
    DateRange.new(:start_date => Time.now - 30.days,
                  :end_date => Time.now,
                  :name => "Last 30 Days")
  end
  
  def last_7_days
    DateRange.new(:start_date => Time.now - 7.days,
                  :end_date => Time.now,
                  :name => "Last 7 Days")
  end
  
  def this_week
    DateRange.new(:start_date => Time.now.beginning_of_week - 1.day,
                  :end_date => Time.now,
                  :name => "This Week")
  end
  
  def last_week
    DateRange.new(:start_date => (Time.now.beginning_of_week - 1.week) - 1.day,
                  :end_date => (Time.now.end_of_week - 1.week) - 1.day,
                  :name => "Last Week")
  end
  
  def last_12_months
    DateRange.new(:start_date => Time.now - 12.months,
                  :end_date => Time.now,
                  :name => "Last 12 Months")
  end
  
  def last_6_months
    DateRange.new(:start_date => Time.now - 6.months,
                  :end_date => Time.now,
                  :name => "Last 6 Months")
  end
  
end