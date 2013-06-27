class Cadence < ActiveRecord::Base
  acts_as_stampable
  
  has_many :groups
end
