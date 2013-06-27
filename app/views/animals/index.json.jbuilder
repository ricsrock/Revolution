json.array!(@animals) do |animal|
  json.extract! animal, :name, :updated_by, :created_by
  json.url animal_url(animal, format: :json)
end