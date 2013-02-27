class Household < ActiveRecord::Base
  
  validates :name, :address1, :city, :state, :zip, presence: true
  
  has_many :people, dependent: :destroy
  has_many :phones, :as => :phonable
  has_many :emails, :as => :emailable
  
  accepts_nested_attributes_for :people, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :phones, reject_if: :all_blank, allow_destroy: true
end
