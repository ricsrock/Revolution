module CheckinHelper
  
  def success_names(names)
    if names.empty?
      ''
    elsif names.length == 1
      "#{names.first} was successfully checked in. "
    else
      "#{names.collect {|n| n}.to_sentence} were successfully checked in."
    end
  end
  
  def fail_names(names)
    if names.empty?
      ''
    elsif names.length == 1
      "#{names.first} wasn't checked in. "
    else
      "#{names.collect {|n| n}.to_sentence} were not checked in. "
    end
  end
  
end
