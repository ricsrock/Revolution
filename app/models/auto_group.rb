class AutoGroup < ActiveRecord::Base
  belongs_to :instance_type
  belongs_to :group
  
  validates :instance_type_id, :group_id, :presence => true
end
