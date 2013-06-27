class Room < ActiveRecord::Base
  has_many :groups, inverse_of: :default_room, foreign_key: :default_room_id, dependent: :restrict_with_exception
end
