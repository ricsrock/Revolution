class Setting < ActiveRecord::Base
  FIELD_TYPES = %w[text_area string boolean date datetime]
  
  acts_as_stampable
  
  serialize :value
  
  # attr_accessor :key_is
  
  def_druthers :inquiry_email_body
  
  before_validation(on: :create) do
    self.key = self.key.parameterize.underscore
  end
  
  # def key=(value)
  #   value.parameterize.underscore
  # end
  
  def self.default_inquiry_email_body
    "Thanks for inquiring about small groups. Here's more info about this group."
  end
  
  # def key_is=(v)
  #   self.key = v
  # end
  
end
