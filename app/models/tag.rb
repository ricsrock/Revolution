class Tag < ActiveRecord::Base
  belongs_to :tag_group, :class_name => "TagGroup", :foreign_key => "tag_group_id"
  has_many :taggings, dependent: :restrict_with_exception
  
  validates :name, :presence => true, :uniqueness => true
  
  acts_as_stampable
    
  def full_name
    self.tag_group.name + ': ' + self.name
  end
end
