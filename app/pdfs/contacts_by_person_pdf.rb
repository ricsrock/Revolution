class ContactsByPersonPdf < Prawn::Document
  def self.summary(pdf, contacts, view)
    @view = view
    pdf.move_down 5
    pdf.text "#{@view.pluralize(contacts.size, 'contact')} to report.", style: :italic
    pdf.move_down 20
    contacts = contacts.select { |c| c.contactable.present? }
    contacts.sort_by {|c| c.stamp}.group_by {|t| t.stamp}.each do |stamp, contacts|
      pdf.text stamp + ' - ('+ @view.pluralize(contacts.size, 'contact') + ')'
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
    pdf.text "#{@view.pluralize(contacts.size, 'contact')} to report.", style: :italic
    pdf.move_down 20
    contacts = contacts.select { |c| c.contactable.present? }
    contacts.sort_by {|c| c.stamp}.group_by {|t| t.stamp}.each do |stamp, contacts|
      pdf.text stamp + ' - ('+ @view.pluralize(contacts.size, 'contact') + ')'
      pdf.stroke_horizontal_rule
      pdf.move_down 5
      pdf.text "#{@view.contact_names_with_ages(contacts.first)}", style: :italic
      pdf.move_down 20
      data = []
      contacts.sort_by {|c| [c.contact_type.name, c.created_at]}.each do |contact|
        attrs = []
        attrs << contact.contact_type.name
        attrs << contact.created_at.strftime('%x')
        attrs << contact.comments
        data << attrs
      
      pdf.table data, row_colors: ["f0f0f0", "fcfcfc"], cell_style: {borders: []}, width: 540
      pdf.move_down 20
      
      #   # contact.contactable.contacts.limit(10).order(:created_at).each do |c|
      #   #   pdf.text_box "#{c.created_at.strftime('%x')} - #{c.contact_type.name}: #{c.comments}", at: [30, pdf.cursor]
      #   #   pdf.move_down 15
      #   # end
        if contact.contactable.is_a?(Person)
          pdf.text_box "Tags:", at: [30, pdf.cursor], style: :bold
          pdf.move_down 15
          contact.contactable.taggings.includes(tag: :tag_group).order(:start_date).each do |t|
            pdf.text_box "#{t.start_date.strftime('%x') rescue nil} - #{t.tag.full_name}: #{t.comments}", at: [50, pdf.cursor]
            pdf.move_down 15
          end
          pdf.move_down 20
        end
      end  
    end
  end
end
