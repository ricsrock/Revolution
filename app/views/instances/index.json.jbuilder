json.array!(@instances) do |instance|
  json.extract! instance, :event_id, :instance_type_id
  json.url instance_url(instance, format: :json)
end