json.array!(@enrollments) do |enrollment|
  json.extract! enrollment, 
  json.url enrollment_url(enrollment, format: :json)
end