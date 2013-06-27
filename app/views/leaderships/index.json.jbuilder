json.array!(@leaderships) do |leadership|
  json.extract! leadership, :leadable_id, :leadable_type, :type, :person_id, :title
  json.url leadership_url(leadership, format: :json)
end