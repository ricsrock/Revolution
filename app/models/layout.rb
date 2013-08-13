class Layout < ActiveRecord::Base
  belongs_to :record_type, :class_name => "RecordType", :foreign_key => "record_type_id"
  validates :name, :record_type_id, :presence => true
  validates :name, uniqueness: { scope: :record_type_id }
end
