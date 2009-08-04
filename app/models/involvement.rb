class Involvement < ActiveRecord::Base
  belongs_to :job
  belongs_to :person
  has_many :assignments, :dependent => :destroy
  has_many :deployments, :dependent => :destroy
  
  acts_as_paranoid
  
  validates_presence_of :person_id
  validates_presence_of :job_id
  validates_uniqueness_of :person_id, :scope => :job_id
  
  delegate :full_name, :last_first_name, :to => "person.nil? ? false : person"
  
  after_save {|record| record.person.set_involved
                       record.person.set_connected}
                       
  after_destroy {|record| record.person.set_involved
                          record.person.set_connected}
  
  
  def person_name
    self.person.full_name
  end
  
  def phone
    self.person.household_emergency_phone
  end
  
  def email_address
    self.person.household_best_email
  end
  
  def self.find_by_team(team_id)
    find(:all,
         :include => [{:person => :household}],
         :joins => ['JOIN jobs ON involvements.job_id = jobs.id'], 
         :conditions => ['jobs.team_id = ?', team_id])
    
  end
  
  def has_email?
    if self.person.household_best_email
      true
    else
      false
    end
  end
  
  def status
    if (self.end_date > Date.today unless self.end_date.nil?) or self.end_date.nil?
        "Current"
    else
        "Past"
    end
  end
  
end
