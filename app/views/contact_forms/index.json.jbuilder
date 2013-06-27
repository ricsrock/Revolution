json.array!(@contact_forms) do |contact_form|
  json.extract! contact_form, :name
  json.url contact_form_url(contact_form, format: :json)
end