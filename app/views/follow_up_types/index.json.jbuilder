json.array!(@follow_up_types) do |follow_up_type|
  json.extract! follow_up_type, :name
  json.url follow_up_type_url(follow_up_type, format: :json)
end