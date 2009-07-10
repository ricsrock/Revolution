class Contact < ActiveRecord::Base
  belongs_to :person
  belongs_to :household
  belongs_to :responsible_user, :class_name => "User", :foreign_key => "responsible_user_id"
  belongs_to :responsible_ministry, :class_name => "Ministry", :foreign_key => "responsible_ministry_id"
  belongs_to :contact_type
  has_many :follow_ups
  
  acts_as_paranoid
  
  require 'faster_csv'
  
  after_create :deliver_notify_email
  after_create :do_attribution_stamp
  
  validates_presence_of :contact_type_id, :responsible_user_id
  
  STATUS = ["Any", "Open", "Closed"]
  SORT_BY = ["Date Opened", "Contact Type", "Attributed To"]
  RANGES = ["All", "This Week", "Last 7 Days", "Last 14 Days", "This Month", "Last 30 Days", "Year To Date"]
  CHOICES = ["Multi-Close", "Export Mail Merge File"]
  
  def attributed_to
    #TODO: Make this method return the name of the person if person or the name of the household if household...
    # ...a nice little image tag would be nice too.
    if ! self.person.nil?
      self.person.full_name
    elsif ! self.household.nil?
      self.household.household_name
    else
      "Unattributed"
    end
  end
  
  def attribution_stamp
      if ! self.person.nil?
        self.person.last_first_name + ' (' + self.person.id.to_s + ')'
      elsif ! self.household.nil?
        self.household.name + ' (' + self.household.id.to_s + ')'
      else
        "Unattributed"
      end
    end
    
    
  
  def name_sort
    if ! self.person.nil?
      self.person.last_first_name
    elsif ! self.household.nil?
      self.household.name
    else
      "Unattributed"
    end
  end
  
  def all_contacts
    if ! self.person.nil?
      self.person.contacts
    elsif ! self.household.nil?
      self.household.contacts
    else
      "none"
    end
  end
  
  def all_tags
    if ! self.person.nil?
      self.person.taggings
    end
  end
  
  def household_people
    if ! self.person.nil?
      self.person.household.people
    elsif ! self.household.nil?
      self.household.people
    else
      "none"
    end
  end
  
  
  def assigned_to
    if not self.responsible_user.nil?
      self.responsible_user.full_name
    elsif not self.responsible_department.nil?
      self.responsible_department.name
    else
      "Unassigned"
    end
  end
  
  def days_old
    self.created_at.time_ago_in_words
  end
  
  def age_in_days
    (Time.now - self.created_at)/(60*60*24)
  end
  
  def status
    if self.closed_at
        if self.reopen_at
            if self.reopen_at > Time.now or self.reopen_at < self.closed_at
                "closed"
            elsif self.follow_ups.length > 0
                "in progress"
            else
                "closed"
            end
        else
            "closed"
        end
    elsif self.follow_ups.length > 0
      "in progress"
    else 
      "open"
    end
  end
  
  def self.find_by_user_id_open_order(user_id,open,order)
    find(:all, :conditions => ['responsible_user_id LIKE ? AND open LIKE ?', user_id, open],
               :order => [order])
  end
  
  def self.find_by_open_order(open,order)
    find(:all, :conditions => ['open LIKE ?', open],
               :order => [order])
  end
  
  def self.find_with_ez_where(status_result,login_result,order_result,range_result,type_result)
    sql_conditions = []
    
    unless login_result == ""
      user = User.find(:all, :conditions => ['login LIKE ?',login_result])
      login_cond = Caboose::EZ::Condition.new do
        responsible_user_id == user
      end
      sql_conditions << login_cond
    end
    
    unless status_result == "Any"
      if status_result == "Open"
        status_sql = "((contacts.closed_at IS NULL) OR ((contacts.reopen_at > contacts.closed_at) AND (contacts.reopen_at < '#{Time.now.to_s(:db)}')))"
        status_result = "1"
      else
        status_sql = "((contacts.closed_at IS NOT NULL) AND ((contacts.reopen_at IS NULL) OR ((contacts.reopen_at > '#{Time.now.to_s(:db)}') OR (contacts.reopen_at < contacts.closed_at))))"
        status_result = "0"
      end
      openn_cond = Caboose::EZ::Condition.new do
        openn == status_result
      end
      sql_conditions << status_sql
    end
    
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
      elsif range_name == "Year To Date"
        start_range = (Time.now.beginning_of_year)
        end_range = Time.now
      end
      range_condition = Caboose::EZ::Condition.new :contacts do
        created_at <=> (start_range..end_range)
      end
      sql_conditions << range_condition
    end
    
    unless type_result == ""
        type_id = type_result.to_i
        type_condition = Caboose::EZ::Condition.new :contacts do
            contact_type_id == type_id
        end
        sql_conditions << type_condition
    end
    
    combined_cond = Caboose::EZ::Condition.new
    sql_conditions.each do |item|
      combined_cond << item
    end
    
    if order_result == "Date Opened"
      order = 'contacts.created_at ASC'
    elsif order_result == "Contact Type"
      order = 'contact_types.name ASC'
    else
      order = 'person_id, household_id ASC'
    end
    
    find(:all, :conditions => combined_cond.to_sql, :include => [:follow_ups, :contact_type], :order => order)
  end
  
  def self.do_something(array_of_ids)
    array_of_ids.each do |id|
      Contact.new(:comments => id).save
    end
  end
  

  
  
  def export_group
      @group = Group.find(params[:id])

      csv_string = FasterCSV.generate do |csv|
        csv << ["FirstName", "LastName", "Address1", "Address2", "City", "State", "Zip", "Phone", "Email"]

        @group.enrollments.each do |enrollment|
          csv << [enrollment.person['first_name'],
                  enrollment.person['last_name'],
                  enrollment.person.household['address1'],
                  enrollment.person.household['address2'],
                  enrollment.person.household['city'],
                  enrollment.person.household['state'],
                  enrollment.person.household['zip'],
                  enrollment.person.household.best_phone_s_formatted,
                  enrollment.person.household.best_email['email']]
        end
      end

      filename = @group.name.downcase.gsub(/[^0-9a-z]/, "_") + ".csv"
      send_data(csv_string,
        :type => 'text/csv; charset=utf-8; header=present',
        :filename => filename)
    end
    
    def self.weekly_report
      find(:all, 
           :include => [:contact_type],
           :conditions => ["(contacts.created_at > '#{(Time.now.beginning_of_week - 1.day).to_s(:db)}') AND
                            contact_types.name IN ('1st Visit Letter','2nd Visit Letter','3rd Visit Letter','Guest Reception Invite')"])
    end
    
    def self.weekly_prayer_praise
      find(:all, 
           :include => [:contact_type],
           :conditions => ["(contacts.created_at > '#{(Time.now.beginning_of_week - 1.day).to_s(:db)}') AND
                            contact_types.name IN ('Prayer Request','Praise Report')"],
            :group => ['stamp'],
            :order => ['stamp'])
    end
    
    def self.weekly_by_stamp_and_type_name(stamp,contact_types)
      find(:all, 
           :include => [:contact_type],
           :conditions => ["(contacts.created_at > '#{(Time.now.beginning_of_week - 1.day).to_s(:db)}') AND
                            contacts.stamp LIKE ? AND
                            contact_types.name IN (?)", stamp,contact_types],
            :order => ['stamp'])
    end
    
    def transfer(email)
        unless self.responsible_user_id.nil?
            user = User.find(self.responsible_user_id)
            #current_user = User.find_by_login(self.created_by)
            current_user_email = email
            #current_user_email = User.find_by_login(self.created_by).email
            VolunteerMailer.deliver_contact_transfer_notify(user, current_user_email, self)
        end
    end
    
    def deliver_follow_up_notify_email
        unless self.responsible_user_id.nil?
            unless self.created_by == 'system'
                if self.contact_type.notiphy?
                    responsible_user = User.find(self.responsible_user_id)
                    created_by_user = User.find_by_login(self.created_by)
                    VolunteerMailer.deliver_follow_up_notify(responsible_user,created_by_user, self)
                end
            end
        end
    end
    
    ######
    private
    #####
    
  def deliver_notify_email
      unless self.responsible_user_id.nil?
          user = User.find(self.responsible_user_id)
          current_user = User.find_by_login(self.created_by)
          current_user_email = current_user ? current_user.email : "admin@rivervalleychurch.net"
        # if ! self.created_by == 'system'
        #     current_user_email = User.find_by_login(self.created_by).email
        # else
        #     current_user_email = 'admin@rivervalleychurch.net'
        # end
          VolunteerMailer.deliver_contact_notify(user, current_user_email, self)
      end
  end
        
    def do_attribution_stamp
        self.update_attribute(:stamp, self.attribution_stamp)
    end
    
  

  
  
end
