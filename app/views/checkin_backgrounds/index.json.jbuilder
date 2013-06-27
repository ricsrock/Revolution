json.array!(@checkin_backgrounds) do |checkin_background|
  json.extract! checkin_background, :name, :graphic
  json.url checkin_background_url(checkin_background, format: :json)
end