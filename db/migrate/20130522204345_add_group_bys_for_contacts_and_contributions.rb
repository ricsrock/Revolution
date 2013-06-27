class AddGroupBysForContactsAndContributions < ActiveRecord::Migration
  def change
    record_type = RecordType.find_by_name("Contacts")
    ["Person", "Contact Type"].each do |g|
      record_type.group_bys.create(column_name: g)
    end
    
    record_type = RecordType.find_by_name("Contributions")
    ["Person", "Fund"].each do |g|
      record_type.group_bys.create(column_name: g)
    end
  end
end
