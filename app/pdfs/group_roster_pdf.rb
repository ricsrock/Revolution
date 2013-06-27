class GroupRosterPdf < Prawn::Document
  
  def initialize(group, view)
    super(top_margin: 70)
    super(bottom_margin: 70)
    # super(page_layout: :landscape)
    @group = group
    @view = view
    FooterPdf.header(self)
    group_name
    people_list
    FooterPdf.footer(self)
  end
  
  def group_name
    font "Times-Roman", size: 12
    text "#{@group.name}", style: :bold, size: 18
    stroke_horizontal_rule
  end
  
  def people_list
    move_down 20
    if @group.has_children?
      @enrollments = @group.descendants_enrollments
    else
      @enrollments = @group.enrolled('current').sort_by {|e| e.person.last_first_name}
    end
    @enrollments.each do |enrollment|
      text "#{enrollment.person.full_name}", style: :bold
      y_position = cursor
      bounding_box [0, cursor], :width => 159 do
        text "#{enrollment.person.address1}"
        text "#{enrollment.person.city}, #{enrollment.person.state} #{enrollment.person.zip}"
      end
      bounding_box [160, y_position], :width => 150 do
        enrollment.person.phones.each do |p|
          text "#{@view.number_to_phone p.number} (#{p.comm_type.name})"
        end
      end
      bounding_box [320, y_position], width: 200 do
        enrollment.person.emails.each do |m|
          text "#{m.email} (#{m.comm_type.name})"
        end
      end
      move_down 60
      if cursor < 65
        start_new_page
      end
    end
  end
  
  
end