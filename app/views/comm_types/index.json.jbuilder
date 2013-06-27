json.array!(@comm_types) do |comm_type|
  json.extract! comm_type, 
  json.url comm_type_url(comm_type, format: :json)
end