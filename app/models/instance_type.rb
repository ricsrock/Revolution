class InstanceType < ActiveRecord::Base
  has_many :instances
  has_many :auto_groups
  has_many :groups, :through => :auto_groups
    
end
