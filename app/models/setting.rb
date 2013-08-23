class Setting < ActiveRecord::Base
  FIELD_TYPES = %w[text_area string boolean date datetime]
  
  acts_as_stampable
  
  serialize :value
  
  def_druthers :inquiry_email_body
  
  def self.default_inquiry_email_body
    "Thanks for inquiring about small groups. Here's more info about this group."
  end
  
end
