class RecordType < ActiveRecord::Base
  has_many :group_bys, dependent: :destroy
  has_many :layouts, dependent: :destroy
  has_many :reports, dependent: :restrict_with_exception
  
  validates :name, :uniqueness => true
end
