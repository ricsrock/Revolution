class Household < ActiveRecord::Base
  has_many :people, :conditions => ['people.deleted_at IS NULL AND people.household_position <> "Deceased"']
  has_many :emails, :as => :emailable
  has_many :phones, :as => :phonable
  has_many :notes, :as => :noteable
  has_many :attendances, :through => :people
  has_many :active_attendances, :class_name => "Attendance", :through => :people, :conditions => {:checkout_time => nil}
  has_many :contacts, :order => ['created_at, contact_type_id ASC']
  
  validates_length_of :address1, :minimum => 10, :message => "seems too short."
  validates_length_of :zip, :minimum => 4, :message => "is too short."
  validates_presence_of :name, :message => "The household must have a last name."
  validates_presence_of :city, :message => "The household must have a city."
  validates_presence_of :state, :message => "The household must have a state."
  
  
  
  acts_as_paranoid
  acts_as_mappable
  
  before_destroy :verify_no_people, :verify_no_contacts
  before_validation_on_create :stamp_address, :geocode_address
  after_create :stamp_address
  #after_update :stamp_address
  
  
  def self.actives
    Household.find(:all, :conditions => ['attendance_status = ?', "Active"])
  end
  
  def household_name
    'The' + ' ' + self.name + ' ' + 'Household'
  end
  
  def search_order
    self.name + "               "[0..15-self.name.length]
  end
  
  def address_stamp
      if ! self.address1.nil? or self.city.nil? or self.state.nil? or self.zip.nil?
          self.address1 + ', ' + self.city + ', ' + self.state
      end
  end
  
  def url_for
     	"/households/show/#{id}"
	end
	
	def address_block
	  block = '<span>'
	  unless self.address1.blank?
	    block << self.address1 + '<br>'
    end
    unless self.address2.blank?
      block << self.address2 + '<br>'
    end
    unless self.city.blank?
    block << self.city + ' '
    end
    unless self.state.blank?
      block << self.state + '  '
    end
    unless self.zip.blank?
      block << self.zip.to_s + '<br>'
    end
	  block << '</span>'
	  block
	end
	
	def address_one_line
	  block = '<span>'
	  unless self.address1.blank?
	    block << self.address1 + ' '
    end
    unless self.address2.blank?
      block << self.address2 + ' '
    end
    unless self.city.blank?
    block << self.city + ' '
    end
    unless self.state.blank?
      block << self.state + '  '
    end
    unless self.zip.blank?
      block << self.zip.to_s
    end
	  block << '</span>'
	  block
	end
	

	
	
	def first_phone
	  Phone.find(:first,
	             :conditions => ['phonable_id = ?', self.id])
	end
	
	def primary_phone
	 Phone.find(:first, :conditions => ['phonable_id = ? AND phones.primary LIKE ?', self.id, 1])
	end
	
	def best_phone
	  @result = self.primary_phone
	  @result ||= self.first_phone
	  @result ||= 'none'
	end
	
	def best_phone_s_formatted
	 unless self.best_phone == 'none'
	   best_phone.s_formatted
   else
     'none'
   end
	end
	
	#def household_first_phone
	#  Phone.find(:first, :conditions => ['phonable_id = ?', self.household_id])
	#end
	
	def first_email
	 Email.find(:first, :conditions => ['emailable_id = ?', self.id])
	end
	
	def primary_email
	 Email.find(:first, :conditions => ['emailable_id = ? AND emails.primary LIKE ?', self.id, 1])
	end
	
	def best_email
	  @result = self.primary_email
	  @result ||= self.first_email
	  @result ||= 'none'
	end
	
	def best_email_smart
	  self.best_email == "none" ? "none" : self.best_email.email
	end
	
	def self.find_by_first_letter(letter)
	  conditions = "#{letter}%"
	  find(:all, :conditions => ['name LIKE ?', conditions], :order => ['name ASC'])
	end
	
	def set_attendance_status
	   @people_statuses = self.people.collect {|p| p.attendance_status}
	   if @people_statuses.compact.uniq.include?("Active")
	       status = "Active"
       elsif @people_statuses.compact.uniq.length == 1 && @people_statuses.compact.uniq.include?("Guest")
           status = "Guest"
       else
           status = "Inactive"
       end
       self.update_attribute(:attendance_status, status)
	end
	
	def self.find_deleted
	   find_by_sql('SELECT * FROM households WHERE deleted_at IS NOT NULL')
	end
	
	def self.find_deleted_id(id)
	    find_by_sql("SELECT * FROM households WHERE id = #{id}")
	end
	
	def pub_geocode_address
	    if self.address
            geo = GeoKit::Geocoders::MultiGeocoder.geocode(address)
            #errors.add(:address, "Could not geocode address") unless geo.success
            self.update_attributes(:lat => geo.lat, :lng => geo.lng) if geo.success
            #self.lat, self.lng = geo.lat, geo.lng if geo.success
        end
        geo.success ? true : false
    end
    
    def people_in_order
      self.people.sort_by(&:sort_order).collect {|p| p.family_name}.to_sentence
    end
	
	######
	protected
	#####
	
	def verify_no_people
	    if ! self.people.empty?
	        errors.add_to_base("You can't delete a household with people in it.")
	        false
        else
            true
        end
    end
    
    def verify_no_contacts
	    if ! self.contacts.empty?
	        errors.add_to_base("You can't delete a household that has contacts.")
	        false
        else
            true
        end
    end
    
    def stamp_address
        self.address = self.address_stamp
    end
    
    def geocode_address
        geo = GeoKit::Geocoders::MultiGeocoder.geocode(address)
        #errors.add(:address, "Could not geocode address") unless geo.success
        self.lat, self.lng = geo.lat, geo.lng if geo.success
    end
  
end
