class Associate < ActiveRecord::Base
  belongs_to :organization, :foreign_key => 'organization_id'
  
  Associate.partial_updates = false
  
  def full_name
    self.first_name + ' ' + self.last_name rescue nil
  end
end
