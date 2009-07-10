class CheckinType < ActiveRecord::Base
  has_many :attendances
end
