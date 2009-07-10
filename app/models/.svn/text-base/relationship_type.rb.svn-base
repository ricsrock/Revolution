class RelationshipType < ActiveRecord::Base
  has_many :relationship_roles
  
  validates_exclusion_of :name, :in => %w(Friend friend), :message => "Come on, be more specific!"
end
