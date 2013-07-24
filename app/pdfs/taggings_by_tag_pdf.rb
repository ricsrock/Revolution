class TaggingsByTagPdf < Prawn::Document
  def self.summary(pdf, taggings, view)
    @view = view
    pdf.move_down 5
    pdf.text "#{@view.pluralize(taggings.size, 'tag')} to report.", style: :italic
    pdf.move_down 20
    taggings.group_by {|t| t.tag.name}.each do |tag, taggings|
      pdf.text tag + ' ('+ @view.pluralize(taggings.size, 'tag') + ')'
      pdf.stroke_horizontal_rule
      #do a table...
      pdf.move_down 20
      columns = %w[Date Person Family Status]
      data = []
      data << columns
      taggings.sort_by {|t| t.start_date.to_date.to_s(:db)}.each do |tagging|
        attrs = []
        attrs << tagging.start_date.to_date.to_s
        attrs << tagging.person.full_name
        attrs << tagging.person.household.family_names
        attrs << tagging.person.attendance_status
        data << attrs
      end
      pdf.table data, row_colors: ["f0f0f0", "fcfcfc"], header: true, cell_style: {borders: []}, width: 540
      pdf.move_down 20
    end    
  end
  
  def self.detail(pdf, taggings, view)
    @view = view
    pdf.move_down 5
    pdf.text "Sorry, there is no detail layout yet."
  end
  
end
