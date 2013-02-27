json.array!(@meetings) do |meeting|
  json.extract! meeting, :instance_id, :group_id, :room_id, :real_date, :comments, :num_marked
  json.url meeting_url(meeting, format: :json)
end