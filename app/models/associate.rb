class Associate < ActiveRecord::Base
  belongs_to :organization, :foreign_key => 'organization_id'
  
  Associate.partial_updates = false
  
  def full_name
    self.first_name + ' ' + self.last_name rescue nil
  end
  
  def sort_order
    self.last_name + " " + self.first_name
  end
end
