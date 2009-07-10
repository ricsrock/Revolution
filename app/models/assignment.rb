class Assignment < ActiveRecord::Base
  belongs_to :meeting
  belongs_to :involvement
  
  validates_uniqueness_of :involvement_id, :scope => :meeting_id, :message => "Person is already assigned to this meeting."
  
  def date
    self.meeting.instance.event.date
  end
  
  def formatted_date
    unless self.date.blank?
     date.strftime('%m/%d/%Y')
   end
  end
  
  def full_name
    self.involvement.person.full_name
  end
  
  def instance_type
    self.meeting.instance.instance_type.name
  end
  
  def group
    self.meeting.group.name
  end
  
  def team
    self.involvement.job.team
  end
  
  def team_id
    self.involvement.job.team.id
  end
  
  def ministry
    self.involvement.job.team.ministry
  end
  
  def a_id
    self.id.to_s
  end
  
  def self.find_by_team(team_id)
    find(:all, :select => ['assignments.id, events.date as date_sql, instance_types.name as instance_type_name,
                            groups.name as group_name, CONCAT(first_name," ",last_name) as full_name_b, teams.name as team_name, jobs.title as job_title'],
               :conditions => ['jobs.team_id = ?', team_id],
               :joins => ['JOIN involvements ON assignments.involvement_id = involvements.id
                        JOIN jobs ON involvements.job_id = jobs.id
                        JOIN teams ON jobs.team_id = teams.id
                        JOIN meetings ON assignments.meeting_id = meetings.id
                        JOIN instances ON meetings.instance_id = instances.id
                        JOIN events ON instances.event_id = events.id
                        JOIN instance_types ON instances.instance_type_id = instance_types.id
                        JOIN groups ON meetings.group_id = groups.id
                        JOIN people ON involvements.person_id = people.id'],
                :order => ['date_sql ASC'])
  end
  

  
end
