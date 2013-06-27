json.array!(@envolvements) do |envolvement|
  json.extract! envolvement, 
  json.url envolvement_url(envolvement, format: :json)
end