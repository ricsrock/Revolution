json.array!(@follow_ups) do |follow_up|
  json.extract! follow_up, :notes, :contact_id, :created_by, :updated_by, :follow_up_type_id
  json.url follow_up_url(follow_up, format: :json)
end