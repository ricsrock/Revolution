json.array!(@tag_groups) do |tag_group|
  json.extract! tag_group, 
  json.url tag_group_url(tag_group, format: :json)
end