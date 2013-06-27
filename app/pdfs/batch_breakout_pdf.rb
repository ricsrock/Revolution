class BatchBreakoutPdf < Prawn::Document
  
  def initialize(batch, view)
    super(top_margin: 70)
    super(bottom_margin: 70)
    # super(page_layout: :landscape)
    @batch = batch
    @view = view
    batch_name
    batch_attributes
    amounts_balance
    counts_balance
    donations
    footer
  end
  
  def batch_name
    text "Batch ##{@batch.id}: #{@batch.date_collected.to_date.to_s(:long)} - Breakout By Fund", style: :bold
    stroke_horizontal_rule
  end
  
  def donations
    move_down 20
    Fund.all.each do |fund|
      text "Fund: #{fund.name}", style: :bold
      stroke_horizontal_rule
      move_down 10
      # table...
      columns = %w[CheckNum Contributor Amount]
      data = []
      data << columns
      @batch.donations.fund_id(fund.id).sort_by {|d| d.contribution.contributable.search_order}.each do |d|
        attributes = []
        attributes << d.contribution.check_num
        attributes << d.contribution.contributable.full_name
        attributes << @view.number_to_currency(d.amount)
        data << attributes
      end
      font "Helvetica", size: 10
      table data, row_colors: ["f0f0f0", "fcfcfc"], header: true, cell_style: {borders: []}, width: 540
      move_down 10
      font "Helvetica", size: 12
      text "Fund Total: #{@view.number_to_currency(@batch.donations.fund_id(fund.id).sum(:amount))}", align: :right, style: :bold
      move_down 10
    end
    # columns = %w[CheckNum Contributor Amount Splits]
    # data = []
    # data << columns
    # @batch.contributions.sort_by {|c| c.contributable.search_order}.each do |contribution|
    #   attributes = []
    #   attributes << contribution.check_num
    #   attributes << contribution.contributable.full_name
    #   attributes << @view.number_to_currency(contribution.total)
    #   attributes << contribution.donations.collect {|d|  "#{@view.number_to_currency(d.amount)} to #{d.fund.name}" }.to_sentence
    #   data << attributes
    # end
    # table data, row_colors: ["f0f0f0", "fcfcfc"], header: true, cell_style: {borders: []}, width: 540
  end
  
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
  
  
  def amounts_balance
    if @batch.count_total == @batch.contributions.sum(:total)
      nil
    else
      text "********* THIS BATCH IS NOT BALANCED ********", align: :center
      text "******* AMOUNT DECLARED DOES NOT EQUAL AMOUNT RECORDED ********", align: :center
    end
  end
  
  def counts_balance
    if @batch.contributions_num == @batch.contributions.size
      nil
    else
      text "********* THIS BATCH IS NOT BALANCED ********", align: :center
      text "******* # CONTRIBUTIONS DECLARED DOES NOT EQUAL # RECORDED ********", align: :center
    end
  end
  
  
  def batch_attributes
    move_down 20
    y_position = cursor
    bounding_box [0, cursor], :width => 240 do
      font "Helvetica", size: 10
      text "\u2022 Date Collected: #{@batch.date_collected.to_date.to_s(:long)}"
      text "\u2022 Comments: #{@batch.comments}"
      text "\u2022 Created By: #{@batch.created_by}"
      text "\u2022 Last Updated By: #{@batch.updated_by}"
      text "\u2022 Created At: #{@batch.created_at.to_time.to_s(:long)}"
      text "\u2022 Last Updated At: #{@batch.updated_at.to_time.to_s(:long)}" rescue nil
    end
    bounding_box [250, y_position], :width => 240 do
      text "\u2022 Amount Declared: #{@view.number_to_currency @batch.count_total}" rescue nil
      text "\u2022 Amount Recorded: #{@view.number_to_currency @batch.contributions.sum(:total)}"
      text "\u2022 # Contributions Declared: #{@batch.contributions_num}" rescue nil
      text "\u2022 # Contributions Recorded: #{@batch.contributions.size}" rescue nil
    end
    font "Helvetica", size: 12
    move_down 40
  end
    
  def footer
    repeat(:all, :dynamic => true) do
      font "Times-Roman", size: 12
      draw_text "Printed #{Time.now.to_s(:long)}", :at => [400, -10], :style => :italic
      draw_text "Page #{page_number} of #{page_count}", :at => [400, -22], :style => :italic
    end
  end
      
  
end