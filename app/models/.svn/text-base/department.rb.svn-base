class Department < ActiveRecord::Base
  has_many :ministries
  has_many :teams, :through => :ministries
  has_many :jobs, :through => :teams
  has_many :involvements, :through => :jobs
  has_many :involved_people, :through => :involvements
  belongs_to :responsible_person, :class_name => "Person", :foreign_key => "responsible_person_id"
  
  acts_as_paranoid
  
end
