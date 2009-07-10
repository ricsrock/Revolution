class Enrollment < ActiveRecord::Base
  belongs_to :person
  belongs_to :group
  
  validates_uniqueness_of :person_id, :scope => :group_id, :message => "This person is already enrolled in this group."
  validates_presence_of :person_id
  validates_presence_of :group_id
  
  def has_email?
    return true unless self.person.best_email.nil? or self.person.best_email.email.blank?
  end
  
end
