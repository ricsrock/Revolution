json.array!(@funds) do |fund|
  json.extract! fund, 
  json.url fund_url(fund, format: :json)
end