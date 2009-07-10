class Note < ActiveRecord::Base
  #make this a ploymorphic setup so we can implement notes for people, groups, teams, jobs, etc...
  belongs_to :noteable, :polymorphic => true
  belongs_to :note_type, :class_name => 'NoteType', :foreign_key => :type_id
  
  validates_presence_of :type_id, :created_by

end
