class FixDupRecordTypes < ActiveRecord::Migration
  def change
    tags = RecordType.find_all_by_name('Tags')
    contacts = RecordType.find_all_by_name('Contacts')
    contributions = RecordType.find_all_by_name('Contributions')
    
    while tags.size > 1 do
      f = tags.first
      l = tags.last
      reports = Report.where(record_type_id: l.id)
      reports.each {|r| r.update_attribute(record_type_id: f.id)}
      l.destroy
      tags = RecordType.find_all_by_name('Tags')
    end
    
    while contacts.size > 1 do
      f = contacts.first
      l = contacts.last
      reports = Report.where(record_type_id: l.id)
      reports.each {|r| r.update_attribute(record_type_id: f.id)}
      l.destroy
      contacts = RecordType.find_all_by_name('Contacts')
    end
    
    while contributions.size > 1 do
      f = contributions.first
      l = contributions.last
      reports = Report.where(record_type_id: l.id)
      reports.each {|r| r.update_attribute(record_type_id: f.id)}
      l.destroy
      contributions = RecordType.find_all_by_name('Contributions')
    end
 
  end
end
