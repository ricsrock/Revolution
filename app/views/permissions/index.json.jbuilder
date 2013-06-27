json.array!(@permissions) do |permission|
  json.extract! permission, :resource, :action
  json.url permission_url(permission, format: :json)
end