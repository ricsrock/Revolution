class GroupBy < ActiveRecord::Base
  belongs_to :record_type, :class_name => "RecordType", :foreign_key => "record_type_id"
end
