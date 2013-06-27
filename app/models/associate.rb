class Associate < ActiveRecord::Base
  acts_as_stampable
  
  
  def full_name
    first_name + ' ' + last_name
  end
end
