json.array!(@taggings) do |tagging|
  json.extract! tagging, 
  json.url tagging_url(tagging, format: :json)
end