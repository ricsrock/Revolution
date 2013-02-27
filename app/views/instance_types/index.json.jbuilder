json.array!(@instance_types) do |instance_type|
  json.extract! instance_type, :name
  json.url instance_type_url(instance_type, format: :json)
end