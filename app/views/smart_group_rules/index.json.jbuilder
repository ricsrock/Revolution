json.array!(@smart_group_rules) do |smart_group_rule|
  json.extract! smart_group_rule, 
  json.url smart_group_rule_url(smart_group_rule, format: :json)
end