class Tag < ActiveRecord::Base
  belongs_to :tag_group
  has_many :taggings
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def self.find_by_tag_group(tag_group)
    find(:all, :conditions => [:tag_group_id => tag_group])
  end
  
end
