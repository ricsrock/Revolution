class Relationship < ActiveRecord::Base
  belongs_to :person
  belongs_to :related_person, :class_name => "Person", :foreign_key => "relates_to_id"
  belongs_to :relationship_type
  belongs_to :person_role, :class_name => "RelationshipRole", :foreign_key => "person_role_id"
  belongs_to :relates_to_role, :class_name => "RelationshipRole", :foreign_key => "relates_to_role_id"
  
  validates_presence_of :person_id
  validates_presence_of :relationship_type_id
  validates_presence_of :relates_to_id
  validates_presence_of :person_role_id
  validates_presence_of :relates_to_role_id
  
  
  def full_sentence
    self.person.full_name + " is "+ Tool.articlyze(self.relationship_type.name)+" (" + self.relationship_type.name + ") " + self.person_role.name + " of " + self.related_person.full_name + " (" + self.relates_to_role.name + ")"
    rescue
  end
  
  def relationships
    Relationship.find(:all, :conditions => {:person_id => self.relates_to_id})
  end
  
  def new_relationships(person)
    Relationship.find(:all, :conditions => ['person_id = ? AND relates_to_id != ? AND person_id !=?', self.relates_to_id, person.id,person.id])
  end
  
  def active?
    if self.deactivated_on.nil? or (self.deactivated_on > Time.now unless self.deactivated_on.nil?)
      true
    else
      false
    end
  end
  
  
  
  
end
