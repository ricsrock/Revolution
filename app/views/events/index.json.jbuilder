json.array!(@events) do |event|
  json.extract! event, :name, :event_type_id, :date
  json.url event_url(event, format: :json)
end