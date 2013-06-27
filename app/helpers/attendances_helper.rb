module AttendancesHelper
  
  def celebration_sentence_1(attendance)
    i = Interjection.all.collect {|a| a.name}.sample + '!'
    result = i + " We" + "'" + "re so glad to see"
    result.html_safe
  end
  
  def celebration_sentence_2(attendance)
    person = attendance.person
    if person.attend_count < 4
      last_part = "you for the #{person.attend_count.ordinalize} time!"
    else
      last_part = "you for the #{person.attendances_this_year.size.ordinalize} time this year!"
    end
    last_part
  end
  
  def week_x_of_y(attendance)
    "Week #{attendance.date.to_time.strftime('%U')} of 52"
  end
  
end
