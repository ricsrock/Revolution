class Enrollment < ActiveRecord::Base
  belongs_to :group, :class_name => "Group", :foreign_key => "group_id"
  belongs_to :person, :class_name => "Person", :foreign_key => "person_id"
  
  validates :person_id, :group_id, :presence => true
  validates_uniqueness_of :group_id, scope: :person_id, :message => "already enrolled in this group"
  
  validate :cannot_enroll_into_a_group_with_children
  
  
  after_create { |record| 
                    record.person.set_enrolled
               }
               
  after_destroy { |record|
                     record.person.set_enrolled
                }
                
  before_validation :set_default_start_time, on: :create
  
  def self.for_group_id(id)
    where(group_id: id)
  end
  
  def set_default_start_time
    self.start_time ||= Time.now.to_s(:db)
  end
  
  def self.current
    where('enrollments.end_time > ? OR enrollments.end_time IS NULL', Time.zone.now.to_s(:db))
  end
    
  def unenroll!
    self.update_attribute(:end_time, Time.now.to_s(:db))
  end
  
  def re_enroll!
    self.update_attribute(:end_time, nil)
  end
  
  def current?
    (self.end_time == nil or self.end_time > Time.zone.now.to_s(:db)) ? true : false
  end
  
  def cannot_enroll_into_a_group_with_children
    errors.add(:group_id, "You can't enroll someone into a group that has one or more child-groups.") if self.group.has_children?
  end
  
  def self.to_csv(enrollments)
    columns = %w[FirstName LastName Address1 Address2 City State Zip Phone Email BirthDate CreatedBy UpdatedBy]
    
    CSV.generate do |csv|
      csv << columns
      enrollments.each do |n|
        csv << n.attributes_for_export
      end
    end
  end
  
  def attributes_for_export
    attributes = []
    attributes << self.person.first_name
    attributes << self.person.last_name
    attributes << self.person.household.address1
    attributes << self.person.household.address2
    attributes << self.person.household.city
    attributes << self.person.household.state
    attributes << self.person.household.zip
    attributes << self.person.best_number
    attributes << self.person.first_email
    attributes << self.person.birthdate
    attributes << self.person.created_by
    attributes << self.person.updated_by
  end
  
  
end
