class PropertyOperator < ActiveRecord::Base
  belongs_to :smart_group_property, :class_name => "SmartGroupProperty", :foreign_key => "smart_group_property_id"
  belongs_to :operator, :class_name => "Operator", :foreign_key => "operator_id"
  
  validates :smart_group_property_id, :operator_id, :presence => true
  
  validates_uniqueness_of :operator_id, scope: :smart_group_property_id
end
