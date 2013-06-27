class AddGroupBys < ActiveRecord::Migration
  def change
    record_type = RecordType.find_by_name("Tags")
    record_type.group_bys.create(column_name: "Person")
    record_type.group_bys.create(column_name: "Tag")
  end
end
