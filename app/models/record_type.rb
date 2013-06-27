class RecordType < ActiveRecord::Base
  has_many :group_bys
  has_many :layouts
end
