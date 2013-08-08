class Permission < ActiveRecord::Base
  RESOURCES = %w[Contacts SmartGroups Groups Contributions Reports CheckinBackgrounds People Events Meetings SignUps Checkins]
  
  validates :ability_name, :resource_name, :presence => true
  validates :ability_name, uniqueness: { scope: :resource_name }
  
  before_validation :downcase_ability_name
  
  acts_as_stampable
  
  def downcase_ability_name
    self.ability_name = self.ability_name.downcase
  end
  
  def sentence
    "Can #{self.ability_name} #{self.resource_name}."
  end
  
  def self.default_order
    order('permissions.resource_name ASC, permissions.ability_name ASC')
  end
  
end
