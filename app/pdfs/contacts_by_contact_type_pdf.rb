class ContactsByContactTypePdf < Prawn::Document
  def self.summary(pdf, contacts, view)
    @view = view
    pdf.move_down 5
    pdf.text "#{@view.pluralize(contacts.size, 'contact')} to report.", style: :italic
    pdf.move_down 20
    contacts.sort_by {|c| c.contact_type.name}.group_by {|t| t.contact_type.name}.each do |contact_type, contacts|
      pdf.text contact_type + ' ('+ @view.pluralize(contacts.size, 'contact') + ')'
      pdf.stroke_horizontal_rule
      pdf.move_down 20
      data = []
      columns = ["Person", "Date", "Comments", "Responsible", "Status"]
      data << columns
      contacts.sort_by {|c| c.stamp}.each do |contact|
        attrs = []
        attrs << contact.full_name
        attrs << contact.created_at.strftime('%x')
        attrs << contact.comments
        attrs << contact.responsible_user.try(:full_name)
        attrs << contact.status
        data << attrs
      end
      
      pdf.table data, row_colors: ["f0f0f0", "fcfcfc"], header: true, cell_style: {borders: []},
                      column_widths: [108, 58, 228, 88, 58], width: 540
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
    pdf.text "#{@view.pluralize(contacts.size, 'contact')} to report.", style: :italic
    pdf.move_down 20
    contacts.sort_by {|c| c.contact_type.name}.group_by {|t| t.contact_type.name}.each do |contact_type, contacts|
      pdf.text contact_type + ' ('+ @view.pluralize(contacts.size, 'contact') + ')'
      pdf.stroke_horizontal_rule
      pdf.move_down 20
      contacts.sort_by {|c| c.stamp}.each do |contact|
        pdf.formatted_text [{text: "#{contact.full_name}: ", :styles => [:bold]},
                            {text: contact.comments}]
        pdf.text "#{@view.contact_names_with_ages(contact)}", style: :italic
        if contact.contactable
          contact.contactable.contacts.order(:created_at).each do |c|
            pdf.text_box "#{c.created_at.strftime('%x')} - #{c.contact_type.name}: #{c.comments}", at: [30, pdf.cursor]
            pdf.move_down 15
          end
        end
        if contact.contactable.is_a?(Person)
          pdf.text_box "Tags:", at: [30, pdf.cursor], style: :bold
          pdf.move_down 15
          contact.contactable.taggings.order(:start_date).each do |t|
            pdf.text_box "#{t.start_date.strftime('%x') rescue nil} - #{t.tag.full_name}: #{t.comments}", at: [50, pdf.cursor]
            pdf.move_down 15
          end
        end
        pdf.move_down 20
      end
    end
  end
end
