module MessagesHelper
  
  def translate_number(digit)
    case digit
    when "1"
      "one"
    when "2"
      "two"
    when "3"
      "three"
    when "4"
      "four"
    when "5"
      "five"
    when "6"
      "six"
    when "7"
      "seven"
    when "8"
      "eight"
    when "9"
      "nine"
    else
      "ten"
    end
  end
end
