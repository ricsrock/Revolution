json.array!(@my_colors) do |my_color|
  json.extract! my_color, :name, :updated_by, :created_by
  json.url my_color_url(my_color, format: :json)
end