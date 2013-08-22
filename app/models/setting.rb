class Setting < ActiveRecord::Base
  
  def_druthers :inquiry_email_body
  
  def self.default_inquiry_email_body
    "Thanks for inquiring about small groups. Here's more info about this group."
  end
  
end
