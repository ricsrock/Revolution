class Fund < ActiveRecord::Base
  has_many :donations
  
  acts_as_stampable
  
end
