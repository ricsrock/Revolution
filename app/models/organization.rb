class Organization < ActiveRecord::Base
  has_many :associates
  has_many :emails, :as => :emailable
  has_many :phones, :as => :phonable
  has_many :contributions, :as => :contributable, :conditions => ['contributions.deleted_at IS NULL']
  
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
	
	def address_stamp
      if ! self.address1.nil? or self.city.nil? or self.state.nil? or self.zip.nil?
          self.address1 + ', ' + self.city + ', ' + self.state
      end
  end
  
  def url_for
     	"/organizations/show/#{id}"
	end
  

  def first_phone
	  Phone.find(:first,
	             :conditions => ['phonable_id = ? and phonable_type = ?', self.id, 'Organization'])
	end

	def primary_phone
	 Phone.find(:first, :conditions => ['phonable_id = ? AND phones.primary LIKE ? and phonable_type = ?', self.id, 1, 'Organization'])
	end

	def best_phone
	  @result = self.primary_phone
	  @result ||= self.first_phone
	  @result ||= 'none'
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

  def set_recent_contr
    self.update_attribute(:recent_contr, self.contributions.collect {|e| e.date}.uniq.sort.last) unless self.contributions.empty?
  end
  
  def set_contr_count
    self.update_attribute(:contr_count, self.contributions.empty? ? "0" : self.contributions.length)
  end

  def search_order
    self.name
  end

  def full_name
    self.name
  end
end
