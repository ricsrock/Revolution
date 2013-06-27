json.array!(@meeting_times) do |meeting_time|
  json.extract! meeting_time, :time
  json.url meeting_time_url(meeting_time, format: :json)
end