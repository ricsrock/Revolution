json.array!(@reports) do |report|
  json.extract! report, :name, :record_type_id, :group_by, :parameters, :layout, :created_by, :updated_by
  json.url report_url(report, format: :json)
end