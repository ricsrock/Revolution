class FooterPdf < Prawn::Document
  def self.footer(pdf)
    pdf.repeat(:all, :dynamic => true) do
      pdf.font "Times-Roman", size: 12
      pdf.draw_text "Printed #{Time.now.to_s(:long)}", :at => [400, -10], :style => :italic
      pdf.draw_text "Page #{pdf.page_number} of #{pdf.page_count}", :at => [400, -22], :style => :italic
    end
  end
  
  def self.header(pdf)
    logo_path = "#{Rails.root}/app/assets/images/rvc_logo.png"
    pdf.image logo_path, width: 120
    pdf.move_down 5
  end
end
