class Team < ActiveRecord::Base
  belongs_to :ministry
  has_many :jobs, :dependent => :destroy
  has_many :involvements, :through => :jobs
  has_many :involved_people, :through => :involvements, :source => :person,
                             :conditions => ['involvements.deleted_at IS NULL AND jobs.deleted_at IS NULL']
  has_many :assignments, :through => :involvements #not sure about this one!
  belongs_to :responsible_person, :class_name => "Person", :foreign_key => "responsible_person_id"
  belongs_to :ministry
  has_many :rotations, :dependent => :destroy
  has_many :service_links, :dependent => :destroy
  has_many :linked_groups, :through => :service_links, :source => :group
  has_many :distinct_members, :through => :involvements, :source => :person, :uniq => true 
  
  acts_as_paranoid
  
  def self.find_by_ministry_id(ministry_id)
    find(:all, :conditions => ['ministry_id LIKE ?', ministry_id])
  end
  
  def self.find_by_department_ministry(department_id, ministry_id)
    find(:all, :include => [:ministry, {:ministry => :department}],
               :conditions => ['ministries.department_id LIKE ? AND teams.ministry_id LIKE ?', department_id, ministry_id])
  end
  
  def unlinked_groups
    @all_groups = Group.find(:all)
    @linked_groups = self.linked_groups
    @all_groups - @linked_groups
  end
  
  def search_order
      self.name + "               "[0..15-self.name.length]
  end
  
  def url_for
     	"/teams/show/#{id}"
  end
  
end
