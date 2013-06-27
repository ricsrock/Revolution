class AddLayouts < ActiveRecord::Migration
  def change
    record_type = RecordType.find_by_name("Tags")
    record_type.layouts.create(name: "Summary")
    record_type.layouts.create(name: "Detail")
    record_type = RecordType.find_by_name("Contacts")
    record_type.layouts.create(name: "Summary")
    record_type.layouts.create(name: "Detail")
    record_type = RecordType.find_by_name("Contributions")
    record_type.layouts.create(name: "Summary")
    record_type.layouts.create(name: "Detail")
  end
end
