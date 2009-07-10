class Email < ActiveRecord::Base
  belongs_to :emailable, :polymorphic => true
  belongs_to :comm_type, :class_name => "CommType", :foreign_key => "comm_type_id"
  
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+.)+[a-z]{2,})$/i, :message => "appears to be invalid."
end
