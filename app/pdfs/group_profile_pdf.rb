class GroupProfilePdf < Prawn::Document
  
  def initialize(group, view)
    super(top_margin: 70)
    super(bottom_margin: 70)
    # super(page_layout: :landscape)
    @group = group
    @view = view
    FooterPdf.header(self)
    group_name
    group_attributes
    people_list
    # people_list
    FooterPdf.footer(self)
  end
  
  def group_name
    font "Times-Roman", size: 12
    text "Group Profile for: #{@group.name}", style: :bold, size: 18
    stroke_horizontal_rule
  end
  
  def group_attributes
    move_down 20
    y_position = cursor
    bounding_box [0, cursor], :width => 240 do
      text "\u2022 Group Name: #{@group.name}"
      text "\u2022 Created At: #{@group.created_at.to_time.to_s(:long) rescue nil}"
      text "\u2022 Updated At: #{@group.updated_at.to_time.to_s(:long) rescue nil}"
    end
    bounding_box [250, y_position], :width => 240 do
      text "\u2022 Group Type: #{@group.type}"
      text "\u2022 Created By: #{@group.created_by}"
      text "\u2022 Updated By: #{@group.updated_by}"
    end
    move_down 40
  end
  
  def people_list
    move_down 20
    text "Currently Enrolled People", style: :bold
    if @group.has_children?
      @enrollments = @group.descendants_enrollments.order('people.last_name, people.first_name ASC')
    else
      @enrollments = @group.enrolled('current').sort_by {|e| e.person.last_first_name}
    end
    data = []
    headers = %w[Name Age Birthday]
    data << headers
    @enrollments.each do |enrollment|
      row = []
      row << enrollment.person.full_name
      row << enrollment.person.age
      row << enrollment.person.birthdate
      data << row
    end
    table data, row_colors: ["f0f0f0", "fcfcfc"], header: true, cell_style: {borders: []}, width: 540
  end
  
  
end
