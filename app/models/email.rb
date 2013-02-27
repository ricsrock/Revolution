class Email < ActiveRecord::Base
  belongs_to :emailable, :polymorphic => true
  
  validates :emailable_type, :emailable_id, :presence => true
  validates :email,:format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, message: "appears to be an invalid email address" },
                   :presence => true
  
end
