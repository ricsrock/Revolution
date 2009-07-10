class Job < ActiveRecord::Base
  belongs_to :team
  has_many :involvements, :dependent => :destroy
  has_many :assignments, :through => :involvements
  has_many :job_requirements
  belongs_to :contact_person, :class_name => "Person", :foreign_key => "contact_person_id"
  
  def self.find_by_d_m_t(d,m,t)
    find(:all, :select => ['jobs.id, department_id, ministry_id, team_id, title, first_name, contact_person_id'],
               :conditions => ['ministries.department_id LIKE ? AND teams.ministry_id LIKE ? AND jobs.team_id LIKE ?', d,m,t],
               :joins => ['JOIN teams ON teams.id = jobs.team_id
                           JOIN ministries ON ministries.id = teams.ministry_id
                           JOIN people ON people.id = jobs.contact_person_id'])
  end
end
