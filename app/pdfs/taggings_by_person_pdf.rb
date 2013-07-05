class TaggingsByPersonPdf < Prawn::Document
  def self.summary(pdf, taggings)
    pdf.move_down 5
    pdf.text "There are #{taggings.size} tags to report.", style: :italic
    pdf.move_down 20
    taggings.sort_by {|ta| ta.person.last_first_name}.group_by {|t| t.person.full_name_with_id}.each do |person, taggings|
      pdf.text person + ' ('+ taggings.size.to_s + ')'
      pdf.stroke_horizontal_rule
      #do a table...
      pdf.move_down 20
      columns = %w[Date Tag Family Status]
      data = []
      data << columns
      taggings.sort_by {|t| t.start_date}.each do |tagging|
        attrs = []
        attrs << tagging.start_date.to_time.strftime('%x')
        attrs << tagging.tag.full_name
        attrs << tagging.person.household.family_names
        attrs << tagging.person.attendance_status
        data << attrs
      end
      pdf.table data, row_colors: ["f0f0f0", "fcfcfc"], header: true, cell_style: {borders: []}, width: 540
      pdf.move_down 20
    end
  end
  
  def self.detail(pdf, taggings)
    pdf.move_down 5
    pdf.text "There are #{taggings.size} tags to report.", style: :italic
    pdf.move_down 20
    pdf.text "There is no Detail Layout yet. Sorry."
  end
  
end
