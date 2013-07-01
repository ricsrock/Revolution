class ContactsByPersonPdf < Prawn::Document
  def self.summary(pdf, contacts, view)
    @view = view
    pdf.move_down 5
    pdf.text "There are #{contacts.size} contacts to report.", style: :italic
    pdf.move_down 20
    contacts.sort_by {|c| c.person.last_first_name}.group_by {|t| t.person.last_first_name}.each do |person, contacts|
      pdf.text person + ' ('+ contacts.size.to_s + ')'
      pdf.stroke_horizontal_rule
      pdf.move_down 20
      data = []
      # columns = ["Person", "Date", "Comments", "Responsible", "Status"]
      # data << columns
      contacts.sort_by {|c| [c.contact_type.name, c.created_at]}.each do |contact|
        attrs = []
        attrs << contact.contact_type.name
        attrs << contact.comments
        data << attrs
      end
      
      pdf.table data, row_colors: ["f0f0f0", "fcfcfc"], cell_style: {borders: []}, width: 540
      pdf.move_down 20
      
      # contacts.sort_by {|c| c.person.last_first_name}.each do |contact|
      #   pdf.formatted_text [{text: "#{contact.person.full_name}: ", :styles => [:bold]},
      #                       {text: contact.comments}]
      #   pdf.text "#{@view.names_with_ages(contact.person.household)}", style: :italic
      #   contact.person.contacts.order(:created_at).each do |c|
      #     pdf.text_box "#{c.created_at.strftime('%x')} - #{c.contact_type.name}: #{c.comments}", at: [30, pdf.cursor]
      #     pdf.move_down 15
      #   end
      #   pdf.move_down 15
      # end
    end
        
  end
  
  def self.detail(pdf, contacts, view)
    @view = view
    pdf.move_down 5
    pdf.text "There are #{contacts.size} contacts to report.", style: :italic
    pdf.move_down 20
    contacts.sort_by {|c| c.contact_type.name}.group_by {|t| t.contact_type.name}.each do |contact_type, contacts|
      pdf.text contact_type + ' ('+ contacts.size.to_s + ')'
      pdf.stroke_horizontal_rule
      pdf.move_down 20
      contacts.sort_by {|c| c.person.last_first_name}.each do |contact|
        pdf.formatted_text [{text: "#{contact.person.full_name}: ", :styles => [:bold]},
                            {text: contact.comments}]
        pdf.text "#{@view.names_with_ages(contact.person.household)}", style: :italic
        contact.person.contacts.order(:created_at).each do |c|
          pdf.text_box "#{c.created_at.strftime('%x')} - #{c.contact_type.name}: #{c.comments}", at: [30, pdf.cursor]
          pdf.move_down 15
        end
        pdf.text_box "Tags:", at: [30, pdf.cursor], style: :bold
        pdf.move_down 15
        contact.person.taggings.order(:start_date).each do |t|
          pdf.text_box "#{t.start_date.strftime('%x')} - #{t.tag.full_name}: #{t.comments}", at: [50, pdf.cursor]
          pdf.move_down 15
        end
        pdf.move_down 20
      end
    end
  end
end
