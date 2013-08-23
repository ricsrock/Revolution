class Leadership < ActiveRecord::Base
  belongs_to :leadable, polymorphic: true
  belongs_to :person, :class_name => "Person", :foreign_key => "person_id"
  
  # validates :leadable_type, :leadable_id, :person_id, :presence => true
  validates_presence_of :leadable, message: "must have an associated owner"
  
  
  def person_name
    person.try(:id_and_full_name)
  end
  
  def person_name=(stuff)
    input = stuff.split(' ')
    self.person = Person.where(:id => input[0]).first
  end
  
  def name_and_title
    self.person.full_name + ' (' + self.title + ')'
  end
  
  
end
