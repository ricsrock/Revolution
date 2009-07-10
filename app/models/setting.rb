class Setting < ActiveRecord::Base
  
  # outlaw 'destroy' on this model!
  
  def self.one
    find(:first)
  end
  

  
end
