class Operator < ActiveRecord::Base
  belongs_to :smart_group_property
  has_many :smart_group_rules
  
  validates_uniqueness_of :short, :scope => :smart_group_property_id
end
