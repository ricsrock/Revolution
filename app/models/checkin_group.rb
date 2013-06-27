class CheckinGroup < Group
  validates :default_room_id, :presence => true
end