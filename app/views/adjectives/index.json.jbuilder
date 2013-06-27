json.array!(@adjectives) do |adjective|
  json.extract! adjective, :name, :updated_by, :created_by
  json.url adjective_url(adjective, format: :json)
end