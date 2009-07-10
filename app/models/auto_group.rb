class AutoGroup < ActiveRecord::Base
  belongs_to :instance_type
  belongs_to :group
end
