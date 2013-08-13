class FixDupLayouts < ActiveRecord::Migration
  def change
    record_types = %w[Tags Contacts Contributions]
    layouts = %w[Detail Summary]
    
    record_types.each do |r|
      pp "==== doing #{r} =========================="
      r = RecordType.where(name: r).first
      layouts.each do |layout_name|
        layout_group = Layout.where(record_type_id: r.id).where(name: layout_name)
        while layout_group.size > 1 do
          pp " === layout_group.size: #{layout_group.size} ======================"
          f = layout_group.first
          l = layout_group.last
          reports = Report.where(layout_id: l.id)
          reports.each {|p| p.update_attribute(layout_id: f.id)}
          if l.destroy
            pp "=== layout destroyed ======================"
          else
            pp "=== layout could not be destroyed: #{l.errors.full_messages} ======================="
          end
          layout_group = Layout.where(record_type_id: r.id).where(name: layout_name)
        end
      end
    end
  end
end
