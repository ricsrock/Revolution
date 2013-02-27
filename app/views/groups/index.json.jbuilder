json.array!(@groups) do |group|
  json.extract! group, :name, :default_room_id, :staff_ratio, :meeting_is_called, :checkin_group
  json.url group_url(group, format: :json)
end