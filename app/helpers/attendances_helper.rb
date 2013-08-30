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
    last_part || ''
  end
  
  def celebration_sentence(attendance)
    i = Interjection.all.collect {|a| a.name}.sample + '!'
    person = attendance.person
    first_part = ''
    last_part = ''
    if person.last_name.downcase.start_with?('guest')
      first_part = i + " We're so glad you're with us"
      last_part = " today!"
    else
      first_part = i + " We're so glad to see you for the"
    end
    if person.attend_count < 4
      last_part = " #{person.attend_count.ordinalize} time!"
    else
      last_part = " #{person.unique_events_this_year.size.ordinalize} time this year!"
    end
    first_part + last_part
  end
  
  def week_x_of_y(attendance)
    "Week #{attendance.date.to_time.strftime('%U')} of 52"
  end
  
end
