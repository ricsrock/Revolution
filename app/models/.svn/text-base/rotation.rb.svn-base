class Rotation < ActiveRecord::Base
  belongs_to :team
  has_many :deployments, :dependent => :destroy
  
  acts_as_paranoid
  
  def self.find_by_team(team_id)
    find(:all, :conditions => ['team_id = ?', team_id])
  end
  
  def available_involvements
    @all_involved = self.team.involvements
    @deployed_involvements = self.deployments.collect { |d| d.involvement }
    @all_involved - @deployed_involvements    
  end
  
  
end
