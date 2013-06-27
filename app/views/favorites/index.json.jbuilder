json.array!(@favorites) do |favorite|
  json.extract! favorite, :favoritable, :belongs_to
  json.url favorite_url(favorite, format: :json)
end