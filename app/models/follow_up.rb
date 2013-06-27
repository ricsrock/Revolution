class FollowUp < ActiveRecord::Base
  belongs_to :contact, :class_name => "Contact", :foreign_key => "contact_id"
  belongs_to :follow_up_type, :class_name => "FollowUpType", :foreign_key => "follow_up_type_id"
  
  validates :contact_id, :follow_up_type_id, :notes, presence: true
  
  attr_accessor :close, :transfer, :transfer_user_id
  
  acts_as_stampable
  
end
