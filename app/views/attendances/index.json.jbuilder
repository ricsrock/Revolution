json.array!(@attendances) do |attendance|
  json.extract! attendance, :person_id, :meeting_id, :checkin_time, :checkout_time, :checkin_type_id, :security_code, :call_number
  json.url attendance_url(attendance, format: :json)
end