json.array!(@people) do |person|
  json.extract! person, 
  json.url person_url(person, format: :json)
end