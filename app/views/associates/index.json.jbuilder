json.array!(@associates) do |associate|
  json.extract! associate, :first_name, :last_name, :comments
  json.url associate_url(associate, format: :json)
end