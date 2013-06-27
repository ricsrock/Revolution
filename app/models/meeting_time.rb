class MeetingTime < ActiveRecord::Base
  validates :time, :uniqueness => true
  
  before_validation :set_year
  
  acts_as_stampable
  
  def set_year
    self.time = self.time.change(year: '2000', month: '01', day: '01')
  end
  
  def s_time
    self.time.to_time.to_s(:time)
  end

end
