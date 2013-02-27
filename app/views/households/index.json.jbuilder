json.array!(@households) do |household|
  json.extract! household, 
  json.url household_url(household, format: :json)
end