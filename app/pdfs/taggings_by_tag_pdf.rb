class TaggingsByTagPdf < Prawn::Document
  def self.summary(pdf, taggings)
    pdf.move_down 5
    pdf.text "There are #{taggings.size} tags to report.", style: :italic
    pdf.move_down 20
    taggings.group_by {|t| t.tag.name}.each do |tag, taggings|
      pdf.text tag + ' ('+ taggings.size.to_s + ')'
      pdf.stroke_horizontal_rule
      #do a table...
      pdf.move_down 20
      columns = %w[Date Person Family Status]
      data = []
      data << columns
      taggings.sort_by {|t| t.start_date}.each do |tagging|
        attrs = []
        attrs << tagging.start_date
        attrs << tagging.person.full_name
        attrs << tagging.person.household.family_names
        attrs << tagging.person.attendance_status
        data << attrs
      end
      pdf.table data, row_colors: ["f0f0f0", "fcfcfc"], header: true, cell_style: {borders: []}, width: 540
      pdf.move_down 20
    end
    
  end
end
