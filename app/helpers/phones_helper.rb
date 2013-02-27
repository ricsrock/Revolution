module PhonesHelper
  def pretty(phone)
    result = ""
    result = "(" + phone.number[0,3] + ")"
    result += " " + phone.number[3,3] + "-" + phone.number[6,4]
    result
  end
end
