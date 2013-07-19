module MeetingsHelper
  def status_label(meeting)
    if meeting.status == 'Open'
      @result = "<span class='label radius success'>Open</span>"
    elsif meeting.status == 'Closed'
      @result = "<span class='label radius alert'>Closed</span>"
    else
      @result = "<span class='label radius'>Unknown</span>"
    end
    @result.html_safe
  end
end
