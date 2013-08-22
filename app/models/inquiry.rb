class Inquiry < ActiveRecord::Base
  belongs_to :person
  belongs_to :group
  
  validates :person_id, :group_id, :presence => true
  
  acts_as_stampable
end
