class Group < ActiveRecord::Base
  TYPES = %w[SmallGroup List CheckinGroup Branch]
  
  acts_as_nested_set #dependent: :restrict_with_exception
  
  belongs_to :default_room, :class_name => "Room", :foreign_key => "default_room_id"
  
  has_many :meetings, dependent: :restrict_with_exception
  
  has_many :enrollments, dependent: :restrict_with_exception
  has_many :people, through: :enrollments
  
  has_many :meets_ons, dependent: :destroy
  has_many :weekdays, through: :meets_ons
  
  has_many :meets_ats, dependent: :destroy
  has_many :meeting_times, through: :meets_ats
  
  # has_one :frequency, dependent: :destroy
  # has_one :cadence, through: :frequency
  
  belongs_to :cadence
  
  validates :name, :presence => true
  validates :parent_id, :presence => true, :unless => lambda { |s| s.root? }
  validates :checkin_code, :uniqueness => true
    
  validates :type, inclusion: { in: Group::TYPES }, allow_nil: true
  
  before_validation :make_a_branch_above, on: :create
  validate :parent_cannot_have_enrollments, on: :create
  validate :group_with_enrollments_cannot_become_a_branch
  validate :parent_must_be_a_branch
  validate :must_be_a_branch_if_has_children
  
  acts_as_stampable
  
  attr_accessor :included
  
  # before_destroy :group_with_descendants_cannot_be_destroyed
  
  ransacker :status do |parent|
    nil
  end
  
  
  def self.checkin_groups
    where(checkin_group: true).order(:name)
  end
  
  def self.all_parents
    where('parent_id IS NULL OR (rgt - lft > 1)')
  end
  
  def self.all_leaves
    where('parent_id IS NOT NULL AND (rgt - lft = 1)')
  end
  
  def self.active
    where('groups.archived_at IS NULL OR groups.archived_at > ?', Time.zone.now.to_s(:db))
  end
  
  def self.archived
    where('groups.archived_at IS NOT NULL AND groups.archived_at < ?', Time.zone.now.to_s(:db))
  end
  
  def self.status(params_hash)
    if params_hash && params_hash[:status_cont]
      logger.info "status_cont is in the params_hash: #{params_hash[:status_cont]}"
      value = params_hash[:status_cont]
    else
      logger.info "status_cont is not in the params_hash: #{params_hash}"
      value = 'Active'
    end
    case value
    when 'Active'
      self.active
    when 'Archived'
      self.archived
    when 'All'
      self
    else
      self
    end
  end
  
  
  def archive!
    self.update_attribute(:archived_at, (Time.now - 1.minute).to_s(:db))
  end
  
  def activate!
    self.update_attribute(:archived_at, nil)
  end
  
  def available_people
    Person.where('people.id NOT IN 
                  (SELECT enrollments.person_id FROM enrollments WHERE (enrollments.group_id = ?))', self.id).order('last_name, first_name ASC')
  end
  
  
  def convert!(klass)
    logger.info "****** converting #{self.name} to #{klass} ********"
    self.update_attributes(type: klass.constantize.to_s)
  end
  
  def descendants_enrollments
    Enrollment.where('group_id IN (?) AND (enrollments.end_time > ? OR enrollments.end_time IS NULL)',
               self.self_and_descendants.collect {|g| g.id},
               Time.zone.now.to_s(:db)).select(:person_id).uniq.includes(:person => [:emails, :phones => [:comm_type],
               :household => [:phones => :comm_type]]).references(:people, :households, :emails, :phones, :comm_types).
               order('people.last_name, people.first_name ASC')
  end
  
  def enroll!(person)
    enrollment = Enrollment.new
    enrollment.group = self
    enrollment.person = person
    if enrollment.save
      true
    else
      enrollment
    end
  end
  
  def enrolled(value)
    case value
    when 'current'
      logger.info "value = current"
      self.enrollments.where('end_time IS NULL OR end_time > ?', Time.zone.now.to_s(:db)).order('people.last_name, people.first_name ASC').includes(:person).references(:people)
    when 'past'
      self.enrollments.where('end_time < ?', Time.zone.now.to_s(:db)).order('people.last_name ASC, people.first_name ASC').includes(:person).references(:people)
    when 'all'
      logger.info "value = all"
      self.enrollments.order('people.last_name ASC, people.first_name ASC').includes(:person).references(:people)
    end
  end
  
  def has_children?
    self.children.present?
  end
    
  def move_enrollments_to(group)
    self.enrollments.update_all(group_id: group.id)
  end
  
  def partial_name
    self.type ? self.type.underscore : 'group'
  end
  
  def status
    if archived_at.blank? or archived_at > Time.zone.now.to_s(:db)
      'Active'
    elsif archived_at.present? and archived_at < Time.zone.now.to_s(:db)
      'Archived'
    else
      'Unknown'
    end
  end
  
  def destroy
    if ! self.has_children?
      super
    else
      errors.add(:base, "You can't destroy this group because it has child groups.")
      return false
    end
  end
  
  private #
  
  def group_with_descendants_cannot_be_destroyed
    errors.add(:base, "You can't destroy this group because it has child groups.") if self.has_children?
    return false
  end
  
  def make_a_branch_above
    logger.info " ====== calling make_a_branch_above ======= parent group is: #{self.parent.name rescue nil} ======="
    if self.root?
      logger.info "--- self ( #{self.name} ) is a root ---"
      true
    else
      if self.parent.convert!('Branch')
        logger.info " --- converting parent ( #{self.parent.name} ) to Branch --- "
        true
      else
        errors.add(:base, "This group's parent couldn't be converted to a Branch. Remove the parent group's enrollments and try again.")
        false
      end
    end
  end
  
  def parent_cannot_have_enrollments
    errors.add(:base, "This group's parent group has enrollments. We can't do that.") if self.parent.present? && self.parent.enrollments.present?
  end
  
  def group_with_enrollments_cannot_become_a_branch
    errors.add(:type, "This group cannot be a Branch because it has enrollments.") if self.type == 'Branch' && self.enrollments.present?
  end
  
  def parent_must_be_a_branch
    logger.info "===== calling parent_must_be_a_branch == self: #{self.inspect} self.root? #{self.root?}====="
    unless self.root?
      errors.add(:parent_id, "This group's parent is not a branch.") unless Group.find(self.parent_id).type == 'Branch' or self.parent.root? or self.root?
    end
  end
  
  def must_be_a_branch_if_has_children
    logger.info "********* calling must_be_a_branch_if_has_children on #{self.name} ***********"
    errors.add(:type, "This group must be a branch because it has children.") if self.has_children? && self.type != "Branch"
  end
end
