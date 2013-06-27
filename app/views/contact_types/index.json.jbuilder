json.array!(@contact_types) do |contact_type|
  json.extract! contact_type, :name, :default_responsible_user_id, :default_responsible_ministry_id, :multiple_close, :notiphy
  json.url contact_type_url(contact_type, format: :json)
end