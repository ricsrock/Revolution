class RelationshipRole < ActiveRecord::Base
  belongs_to :relationship_type
  
  validates_uniqueness_of :name
end
