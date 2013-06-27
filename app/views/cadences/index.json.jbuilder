json.array!(@cadences) do |cadence|
  json.extract! cadence, :name
  json.url cadence_url(cadence, format: :json)
end