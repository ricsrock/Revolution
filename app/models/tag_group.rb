class TagGroup < ActiveRecord::Base
  has_many :tags, dependent: :restrict_with_exception
  
  accepts_nested_attributes_for :tags, reject_if: :all_blank, allow_destroy: true
  
  acts_as_stampable
  
end
