module EnrollmentsHelper
  def status_badge(enrollment)
    if enrollment.current?
      @result = "<span class='label radius success'>Current</span>"
    else 
      @result = "<span class='label radius alert'>Past</span>"
    end
    @result.html_safe
  end
end
