class Deployment < ActiveRecord::Base
  belongs_to :rotation
  belongs_to :involvement
  
  delegate :full_name, :last_first_name, :to => "involvement.nil? ? false : involvement"
end
