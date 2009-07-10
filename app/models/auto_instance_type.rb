class AutoInstanceType < ActiveRecord::Base
  belongs_to :event_type
  belongs_to :instance_type
end
