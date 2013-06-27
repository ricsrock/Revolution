class FollowUpType < ActiveRecord::Base
  has_many :follow_ups, dependent: :restrict_with_exception
end
