class Fund < ActiveRecord::Base
  has_many :donations
  
  validates_presence_of :name
end
