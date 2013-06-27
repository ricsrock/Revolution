json.array!(@smart_groups) do |smart_group|
  json.extract! smart_group, 
  json.url smart_group_url(smart_group, format: :json)
end