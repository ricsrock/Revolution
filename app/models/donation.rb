class Donation < ActiveRecord::Base
  belongs_to :contribution
  belongs_to :fund
  
  validates_presence_of :fund_id, :message => "You must choose a fund."
  validates_presence_of :amount, :message => "You must enter an amount."
  
  after_create :do_total
  after_update :do_total
  
  FUNDS = ["All Funds", "General Fund", "Building Fund", "Missions"]
  ORDER = ["Name", "Date ASC", "Date DESC", "Amount"]
  
  def do_total
    @contribution = Contribution.find(self.contribution.id)
    @contribution.update_attribute(:total, @contribution.donations.sum(:amount))
  end
  
  def self.find_by_filter(range_name,fund_name,names,order)
    sql_conditions = []
    
    unless fund_name == "All Funds"
      fund_result = fund_name
      fund_cond = Caboose::EZ::Condition.new :funds do
        name =~ fund_result
      end
      sql_conditions << fund_cond
    end
    
    
    unless range_name == "All"
      if range_name == "This Month"
        start_range = Time.now.beginning_of_month
        end_range = Time.now
      elsif range_name == "Last 7 Days"
          start_range = (Time.now - 7.days)
          end_range = Time.now
      elsif range_name == "This Week"
          start_range = Time.now.beginning_of_week
          end_range = Time.now
      elsif range_name == "Last 14 Days"
          start_range = (Time.now - 14.days)
          end_range = Time.now
      elsif range_name == "Last 30 Days"
        start_range = (Time.now - 30.days)
        end_range = Time.now
    elsif range_name == "Year To Date"
      start_range = (Time.now.beginning_of_year)
      end_range = Time.now
      end
      range_condition = Caboose::EZ::Condition.new :contributions do
        date <=> (start_range..end_range)
      end
      sql_conditions << range_condition
    end
    
    if names.length == 1
        last_nayme = '%' + names[0].strip + '%'
        name_condition = Caboose::EZ::Condition.new :people do
            last_name =~ last_nayme
        end
        name_condition.append ['organizations.name LIKE ?', last_nayme], :or
      #name_conditions = ['last_name LIKE ?', params[:person_name].strip + '%']
    elsif names.length >= 2
        last_nayme = names[0].strip + '%'
        first_nayme = names[1].strip + '%'
        name_condition = Caboose::EZ::Condition.new :people do
            last_name =~ last_nayme
            first_name =~ first_nayme
        end
      #name_conditions = ['first_name LIKE ? AND last_name LIKE ?', names[1].strip + '%', names[0].strip + '%']
    end
    sql_conditions << name_condition
    
    
    
    sql_conditions << "(contributions.deleted_at IS NULL)"
    
    combined_cond = Caboose::EZ::Condition.new
    sql_conditions.each do |item|
      combined_cond << item
    end
    
    if order == "Name"
        order_sql = 'people.last_name, people.first_name ASC'
    elsif order == "Amount"
        order_sql = 'donations.amount DESC, people.last_name ASC, people.last_name ASC'
    elsif order == "Date ASC"
        order_sql = 'contributions.date ASC, people.last_name ASC, people.first_name ASC, donations.amount DESC'
    elsif order == "Date DESC"
        order_sql = 'contributions.date DESC, people.last_name ASC, people.first_name ASC, donations.amount DESC'
    end

    #order_sql = 'people.last_name, people.first_name ASC'
    
    find(:all,
               :conditions => combined_cond.to_sql,
               :joins => ['LEFT OUTER JOIN funds ON funds.id = donations.fund_id
                           LEFT OUTER JOIN contributions ON contributions.id = donations.contribution_id
                           LEFT OUTER JOIN people ON people.id = contributions.contributable_id AND contributions.contributable_type = "Person"
                           LEFT OUTER JOIN organizations ON organizations.id = contributions.contributable_id AND contributions.contributable_type = "Organization"'],
               :order => [order_sql])
    end
    
    def date
        self.contribution ? self.contribution.date : false
    end
    
    def self.find_by_fund_id(fund_id)
        sql_conditions = []

        unless fund_id == ""
          fund_result = fund_id
          fund_cond = Caboose::EZ::Condition.new :funds do
            id =~ fund_result
          end
          sql_conditions << fund_cond
        end
        
        deleted_at = "contributions.deleted_at IS NULL"
        
        combined_cond = Caboose::EZ::Condition.new
        sql_conditions.each do |item|
          combined_cond << item
        end
        
        combined_cond.append 'contributions.deleted_at IS NULL'
        
        Donation.find(:all, :include => [:contribution, :fund],
                            :conditions => combined_cond.to_sql)
        
    end
    
    def self.find_by_fund_id_and_date_range(fund_id,date_range)
        Donation.find(:all, :include => [:contribution, :fund],
          :conditions => ["contributions.deleted_at IS NULL AND
                          funds.id = ? AND contributions.created_at BETWEEN ? AND ?",
                          fund_id, date_range[:start_date], date_range[:end_date]])
    end
    

  
end
