json.array!(@batches) do |batch|
  json.extract! batch, 
  json.url batch_url(batch, format: :json)
end