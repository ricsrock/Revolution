class PdfController < ApplicationController
  
  before_filter :login_required
  
  require "pdf/writer"  

  def getpdf
    	@rails_pdf_name = "hello.pdf"
    	@content = "This is dynamic content!!!"
    	send_data _pdf.render, :filename => "hello.pdf",
                          :type => "application/pdf"
  end
  
  def pdf
            _pdf = PDF::Writer.new
            _pdf.select_font "Times-Roman"
            _pdf.text "Hello, Ruby.", :font_size => 72, :justification => :center

            send_data _pdf.render, :filename => "hello.pdf",
                      :type => "application/pdf"
          end
  
  def rescue_action_in_public(exception)
       headers.delete("Content-Disposition")
       super
  end
  
  def rescue_action_locally(exception)
       headers.delete("Content-Disposition")
       super
  end
  
  def other
    
  end
  
end
