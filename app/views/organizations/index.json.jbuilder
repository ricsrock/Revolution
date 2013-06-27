json.array!(@organizations) do |organization|
  json.extract! organization, :name, :address1, :address, :city, :state, :zip
  json.url organization_url(organization, format: :json)
end