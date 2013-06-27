class ReportPdf < Prawn::Document
  
  def initialize(report, view, objects)
    super(top_margin: 50)
    super(bottom_margin: 70)
    # super(page_layout: :landscape)
    @report = report
    @view = view
    @objects = objects
    FooterPdf.header(self)
    report_name
    # people
    # footer
    case @report.record_type.name
    when "Tags"
      case @report.group_by.column_name
      when "Tag"
        TaggingsByTagPdf.send(@report.layout.name.downcase.to_sym, self, @objects)
      when "Person"
        TaggingsByPersonPdf.send(@report.layout.name.downcase.to_sym, self, @objects)
      end
    when "Contacts"
      case @report.group_by.column_name
      when "Contact Type"
        ContactsByContactTypePdf.send(@report.layout.name.downcase.to_sym, self, @objects, @view)
      when "Person"
        ContactsByPersonPdf.send(@report.layout.name.downcase.to_sym, self, @objects)
      end
    end
    
    FooterPdf.footer(self)
  end
  
  def report_name
    font "Times-Roman", size: 12
    
    text "#{@report.name}", style: :bold, size: 18
    stroke_horizontal_rule
  end
  # 
  # def people
  #   move_down 20
  #   font "Helvetica", size: 8
  #   columns = %w[FirstName LastName Address1 Address2 City State Zip Phone Email BirthDate]
  #   data = []
  #   data << columns
  #   @smart_group.result.order('last_name ASC, first_name ASC').each do |person|
  #     attributes = person.attributes_for_export
  #     attributes.slice!(10,2)
  #     data << attributes
  #   end
  #   table data, row_colors: ["f0f0f0", "fcfcfc"], header: true, cell_style: {borders: []}
  # end
  
  # def questions
  #   move_down 20
  #   @appraisal.appraisal_form.sections.each do |section|
  #     text section.name, style: :bold
  #     x_position = 405
  #     y_position = cursor + 12
  #     (1..5).each do |num|
  #       bounding_box [x_position,y_position], :width => 10 do
  #         text num.to_s
  #         x_position = x_position + 20
  #         y_position = y_position - 0
  #       end
  #     end
  #     bounding_box [x_position,y_position], :width => 20 do
  #       text "omit", :size => 10
  #       x_position = x_position + 20
  #       y_position = y_position - 0
  #     end
  #     stroke_horizontal_rule
  #     move_down 5
  #       data = []
  #       section.questions.each do |question|
  #         response =  @appraisal.response_for_this_question(question.id)
  #         data << [question.form_text,
  #                 answer(response.answer)].flatten
  #       end
  #       table data, :column_widths => [400, 20, 20, 20, 20, 20, 40],
  #                   :cell_style => {:borders => []},
  #                   :row_colors => ["F0F0F0","FCFCFC" ]
  #       move_down 40
  #       text "Section Comment:", style: :bold
  #       font "Times-Roman"
  #       Comment.for_appraisal_either_type(@appraisal.id).for_section(section.id).all.each do |c|
  #           text c.note, style: :italic 
  #           text " [#{c.created_by} (#{c.created_at.to_time.to_s(:long)})]", :font => "Times-Roman", :style => :italic
  #        end
  #        move_down 20
  #        font "Helvetica"
  #        #stroke_bounds
  #     end
  #     move_down 20
  # end
  
  
  
  
  # def appraisal_attributes
  #   move_down 20
  #   y_position = cursor
  #   bounding_box [0, cursor], :width => 240 do
  #     font "Helvetica", size: 10
  #     text "\u2022 Employee: #{@appraisal.employee.full_name}"
  #     text "\u2022 Appraiser: #{@appraisal.appraiser.full_name}"
  #     text "\u2022 Appraisal Form: #{@appraisal.appraisal_form.name}"
  #     text "\u2022 Reviewer: #{@appraisal.reviewer.full_name}"
  #     text "\u2022 Approved By: #{@appraisal.approved_by}"
  #     text "\u2022 Approved At: #{@appraisal.approved_at.to_time.to_s(:long)}" rescue nil
  #   end
  #   bounding_box [250, y_position], :width => 240 do
  #     text "\u2022 Certifier: #{@appraisal.certifier.full_name}" rescue nil
  #     text "\u2022 Certifiied By: #{@appraisal.certified_by}"
  #     text "\u2022 Certified At: #{@appraisal.certified_at.to_time.to_s(:long)}" rescue nil
  #     text "\u2022 Last Updated By: #{@appraisal.updated_at.to_time.to_s(:long)}" rescue nil
  #     text "\u2022 Last Updated By: #{@appraisal.updated_by}"
  #   end
  #   font "Helvetica", size: 12
  #   move_down 60
  # end
    
  def footer
    repeat(:all, :dynamic => true) do
      font "Times-Roman", size: 12
      draw_text "Printed #{Time.now.to_s(:long)}", :at => [580, -10], :style => :italic
      draw_text "Page #{page_number} of #{page_count}", :at => [580, -22], :style => :italic
    end
  end
      
  
end