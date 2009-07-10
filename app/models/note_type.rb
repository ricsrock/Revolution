class NoteType < ActiveRecord::Base
  
  has_many :notes
  
  validates_uniqueness_of :name
end
