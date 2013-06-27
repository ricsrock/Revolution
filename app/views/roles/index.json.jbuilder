json.array!(@roles) do |role|
  json.extract! role, :name, :alias, :description
  json.url role_url(role, format: :json)
end