class GroupBy < ActiveRecord::Base
  belongs_to :record_type, :class_name => "RecordType", :foreign_key => "record_type_id"
  
  validates :column_name, :presence => true, :uniqueness => { scope: :record_type_id }
end
