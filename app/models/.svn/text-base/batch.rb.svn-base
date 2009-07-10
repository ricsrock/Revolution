class Batch < ActiveRecord::Base
  has_many :contributions, :conditions => ['contributions.deleted_at IS NULL']
  has_many :donations, :through => :contributions
  
  validates_presence_of :date_collected
  
  acts_as_paranoid
  
  def entered_so_far
    if ! self.contributions.empty?
        self.contributions.sum(:total)
    else
        0
    end
  end
  
  def is_locked?
    if self.locked == false
        false
    else
        true
    end
  end
  
end
