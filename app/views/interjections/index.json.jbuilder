json.array!(@interjections) do |interjection|
  json.extract! interjection, :name, :updated_by, :created_by
  json.url interjection_url(interjection, format: :json)
end