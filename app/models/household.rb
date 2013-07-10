class Household < ActiveRecord::Base
  
  validates :name, :address1, :city, :state, :zip, presence: true
  
  has_many :people, inverse_of: :household, dependent: :restrict_with_exception
  has_many :phones, :as => :phonable, dependent: :destroy
  has_many :emails, :as => :emailable, dependent: :destroy
  has_many :contacts, as: :contactable, dependent: :restrict_with_exception
  
  
  accepts_nested_attributes_for :people, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :phones, reject_if: :all_blank, allow_destroy: true
  
  geocoded_by :address
  acts_as_gmappable :process_geocoding => false, :address => :address
  acts_as_stampable
  
  before_validation :set_address
  after_save :run_geocode, :if => lambda{ |obj| obj.address_changed? }
  
  
  def set_address
    logger.info "set_address was called"
    s = ''
    s << address1 + ' '
    s << address2 + ' '
    s << city + ' '
    s << state + ' '
    s << zip.to_s + ' '
    self.address = s
  end
  
  def run_geocode
    Resque.enqueue(GeocoderWorker, self.id)
  end
  
  def geocode!
    self.geocode
    self.save
  end
    
  def attributes_for_export
    attributes = []
    attributes << self.name
    attributes << self.address1
    attributes << self.address2
    attributes << self.city
    attributes << self.state
    attributes << self.zip
    attributes << self.best_number
    attributes << self.first_email
    attributes << self.created_by
    attributes << self.updated_by
  end
  
  def best_phone
    self.phones.where(primary: true).first || self.phones.first
  end
  
  def best_number
    self.best_phone ? self.best_phone.s_formatted : "no phone"
  end
  
  def first_email
    self.emails.first ? self.emails.first.email : "no email"
  end
  
  def responsible_people
    self.people.where('people.household_position LIKE ? OR people.household_position LIKE ?', "Primary Contact", "Spouse")
      .order(:household_position).collect {|p| p.family_name}.to_sentence
  end
  
  def family_names
    self.people.sort_by { |p| p.sort_order }.collect {|person| person.family_name}.to_sentence
  end
  
  # method used to make polyorphic contacts easier!
  def full_name
    self.name
  end
  
  # method used to make polyorphic contacts easier!
  def first_name
    ''
  end
  
  # method used to make polyorphic contacts easier!
  def last_name
    self.name
  end
  
  # method used to make polyorphic contacts easier!
  def last_first_name
    self.name
  end
  
  
end
