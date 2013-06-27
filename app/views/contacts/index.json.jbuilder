json.array!(@contacts) do |contact|
  json.extract! contact, :contact_type_id, :person_id, :responsible_user_id, :comments
  json.url contact_url(contact, format: :json)
end