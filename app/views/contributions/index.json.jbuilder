json.array!(@contributions) do |contribution|
  json.extract! contribution, 
  json.url contribution_url(contribution, format: :json)
end