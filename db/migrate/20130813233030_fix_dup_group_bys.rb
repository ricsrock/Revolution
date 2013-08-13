class FixDupGroupBys < ActiveRecord::Migration
  def change
    # tag = RecordType.where(name: 'Tags').first
    # contact = RecordType.where(name: 'Contacts').first
    # contribution = RecordType.where(name: 'Contributions').first
    
    record_types = %w[Tags Contacts Contributions]
    group_columns = ['Person', 'Tag', 'Contact Type', 'Fund']
    layouts = %w[Detail Summary]
    record_types.each do |r|
      r = RecordType.where(name: r).first
      group_columns.each do |column_name|
        group_bys = GroupBy.where(record_type_id: r.id).where(column_name: column_name)
        while group_bys.size > 1 do
          f = group_bys.first
          l = group_bys.last
          reports = Report.where(group_by_id: l.id)
          reports.each {|r| r.update_attribute(:group_by_id, f.id)}
          l.destroy
          group_bys = GroupBy.where(record_type_id: r.id).where(column_name: column_name)
        end
      end # column_name
    end # record_type / r
  end
end
