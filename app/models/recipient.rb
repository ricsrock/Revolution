class Recipient < ActiveRecord::Base
  
  belongs_to :person, :class_name => "Person", :foreign_key => "person_id"
  belongs_to :message, :class_name => "Message", :foreign_key => "message_id"
  
  after_create :set_number
  
  def set_number
    update_attribute(:number, "+1" + self.person.mobile_number.to_s)
  end
  
end
