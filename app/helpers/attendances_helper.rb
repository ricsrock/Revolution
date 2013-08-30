module AttendancesHelper
  
  def celebration_sentence_1(attendance)
    unless attendance.person.last_name.downcase.start_with?('guest')
      i = Interjection.all.collect {|a| a.name}.sample + '!'
      result = i + " We" + "'" + "re so glad to see"
      result.html_safe
    end
  end
  
  def celebration_sentence_2(attendance)
    unless attendance.person.last_name.downcase.start_with?('guest')
      person = attendance.person
      if person.attend_count < 4
        last_part = "you for the #{person.attend_count.ordinalize} time!"
      else
        last_part = "you for the #{person.unique_events_this_year.size.ordinalize} time this year!"
      end
      last_part
    end
  end
  
  def celebration_sentence(attendance)
    celebration_sentence_1(attendance) + ' ' + celebration_sentence_2(attendance)
  end
  
  def week_x_of_y(attendance)
    "Week #{attendance.date.to_time.strftime('%U')} of 52"
  end
  
end
