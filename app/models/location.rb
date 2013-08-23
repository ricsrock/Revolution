class Location < ActiveRecord::Base
  has_many :small_groups, dependent: :restrict_with_exception
  
  before_validation do
    self.address = "#{self.address1} #{self.address2} #{self.city} #{self.state} #{self.zip}"
  end
  
  def full_street_address
    "#{address1} #{address2} #{city} #{state} #{zip}"
  end
  
end
