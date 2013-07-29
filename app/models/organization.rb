class Organization < ActiveRecord::Base
  has_many :contributions, as: :contributable, dependent: :restrict_with_exception
  has_many :associates, dependent: :destroy
  has_many :phones, as: :phonable, dependent: :destroy
  has_many :emails, as: :emailable, dependent: :destroy
  
  accepts_nested_attributes_for :associates, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :phones, reject_if: :all_blank, allow_destroy: true
  
  acts_as_stampable
  
  def search_order
    self.name
  end
  
  def full_name
    self.name
  end
  
end
