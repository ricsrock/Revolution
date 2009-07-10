class Job < ActiveRecord::Base
  belongs_to :team
  has_many :involvements, :dependent => :destroy #destroy a job, destroy all involvements...which in turn destroys all assignments and rotation deployments
  has_many :current_involvements, :class_name => "Involvement", :foreign_key => "job_id", :conditions => ["involvements.end_date IS NULL OR involvements.end_date > '#{Time.now.to_date.to_s(:db)}'"]
  has_many :assignments, :through => :involvements
  has_many :job_requirements
  belongs_to :contact_person, :class_name => "Person", :foreign_key => "contact_person_id"
  
  acts_as_paranoid
  
  def self.find_by_d_m_t(d,m,t)
    find(:all, :select => ['jobs.id, department_id, ministry_id, team_id, title, first_name, contact_person_id'],
               :conditions => ['ministries.department_id LIKE ? AND teams.ministry_id LIKE ? AND jobs.team_id LIKE ?', d,m,t],
               :joins => ['JOIN teams ON teams.id = jobs.team_id
                           JOIN ministries ON ministries.id = teams.ministry_id
                           JOIN people ON people.id = jobs.contact_person_id'])
  end
end
