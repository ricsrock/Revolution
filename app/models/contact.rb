class Contact < ActiveRecord::Base
  include NamedDateRanges
  
  acts_as_stampable
  
  
  ACTIONS = [ "Multi-Close", "Export", "Transfer Multiple"]
  STATUSES = [ "Open", "In Progress", "Closed" ]
  
  belongs_to :contact_type, :class_name => "ContactType", :foreign_key => "contact_type_id"
  belongs_to :responsible_user, :class_name => "User", :foreign_key => "responsible_user_id"
  # belongs_to :person, :class_name => "Person", :foreign_key => "person_id"
  belongs_to :contactable, polymorphic: true
  
  has_many :follow_ups
  
  validates :contact_type_id, :responsible_user_id, presence: true
  
  before_validation :set_responsible_user_id, on: :create
  before_validation :set_initial_status, on: :create
  before_validation :set_stamp, on: :create
  
  after_create :notify_user
  
  attr_accessor :included
  
  delegate :first_name, :last_name, :address1, :address2, :city, :state, :zip, :best_number, :first_email, :best_email, :last_first_name, :full_name, to: :contactable, allow_nil: true
  
  ransacker :range_selector do |parent|
    nil
  end
  
  def self.accessible_to_user(user_id)
    user = User.find user_id
    if user.has_role?('confidential') or user.has_role?('admin')
      where('1=1')
    else
      Contact.non_confidential
    end
  end
  
  def self.confidential
    where('contact_types.confidential = 1').includes(:contact_type).references(:contact_types)
  end
  
  def self.non_confidential
    where('contact_types.confidential = 0').includes(:contact_type).references(:contact_types)
  end
  
  def self.for_user(user_id)
    where(responsible_user_id: user_id)
  end
  
  def self.fix_params(params_hash)
    if params_hash[:range_selector_cont].blank?
      logger.info "range selector is blank"
      params_hash
    else
      logger.info "range selector has value: #{params_hash[:range_selector_cont]}"
      range_name = params_hash[:range_selector_cont]
      params_hash = params_hash.except!(:range_selector_cont)
      params_hash.merge!(created_at_gt: do_range(range_name).start_date.to_time.to_s(:db))
      params_hash.merge!(created_at_lt: do_range(range_name).end_date.to_time.to_s(:db))
      params_hash
    end
  end
  
  def self.last_six_days
    where('contacts.created_at > ?', Time.zone.now - 6.days)
  end
  
  def self.magic_includes
    includes(:contact_type, :responsible_user).references(:contact_types, :users).joins("LEFT OUTER JOIN people as people_magic ON (contacts.contactable_id = people_magic.id AND contacts.contactable_type = 'Person')
                                                                                         LEFT OUTER JOIN households as households_magic ON (contacts.contactable_id = households_magic.id AND contacts.contactable_type = 'Household')
                                                                                         LEFT OUTER JOIN taggings ON taggings.person_id = people_magic.id
                                                                                         LEFT OUTER JOIN tags ON tags.id = taggings.tag_id")
  end
  
  def confidential?
    self.contact_type.confidential? ? true : false
  end
  
  def show_status
    if openn && follow_ups.empty?
      "Open"
    elsif openn && ! follow_ups.empty?
      "In Progress"
    elsif ! openn
      "Closed"
    else
      "Unknown"
    end
  end
    
  def set_responsible_user_id
    self.responsible_user_id ||= self.contact_type.default_responsible_user_id
  end
  
  def set_initial_status
    self.status = "Open"
  end
  
  def set_stamp
    if self.contactable
      self.stamp = self.contactable.last_first_name + ' (' + self.contactable.id.to_s + ')'
    else
      self.stamp = 'Unattributed'
    end
  end
  
  def close!
    self.update_attributes(openn: false, closed_at: Time.now.to_s(:db), status: "Closed") unless self.closed?
  end
  
  def closed?
    self.status == "Closed" ? true : false
  end
  
  def open?
    self.status == "Open" ? true : false
  end
  
  def in_progress!
    self.update_attribute(:status, "In Progress")
  end
  
  def transfer!(user_id, follow_up_id)
    self.update_attribute(:responsible_user_id, user_id)
    follow_up = FollowUp.find(follow_up_id)
    user = User.find(user_id)
    follow_up.update_attribute(:notes, follow_up.notes + " (transferred to #{user.full_name})")
  end
  
  def self.open
    where('status LIKE ?', 'Open')
  end
  
  def self.to_csv(contacts)
    columns = %w[FirstName LastName Address1 Address2 City State Zip Phone Email ContactType Comments CreatedBy UpdatedBy]
    
    CSV.generate do |csv|
      csv << columns
      contacts.each do |c|
        csv << c.attributes_for_export
      end
    end
  end
  
  def attributes_for_export
    attributes = []
    attributes << self.first_name
    attributes << self.last_name
    attributes << self.address1
    attributes << self.address2
    attributes << self.city
    attributes << self.state
    attributes << self.zip
    attributes << self.best_number
    attributes << self.best_email
    attributes << self.contact_type.name
    attributes << self.comments
    attributes << self.created_by
    attributes << self.updated_by
  end
  
  def should_notify?
    self.contact_type.notiphy?
  end
  
  def notify_user
    logger.info " ----------- notify_user was called --------------"
    logger.info " ---------------- self#should_notify?: #{self.should_notify?} ---------------"
    if self.should_notify?
      ContactMailer.notification(self).deliver!
    end
  end
  
end
