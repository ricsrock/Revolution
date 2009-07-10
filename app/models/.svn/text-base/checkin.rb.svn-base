class Checkin < ActiveRecord::Base
  
  
  
  def generate_code
    letters = ("A".."Z").to_a
    numbers = ("0".."9").to_a
    newpass = ""
    3.times {|i| newpass << letters[rand(letters.size-1)]}
    3.times {|i| newpass << numbers[rand(numbers.size-1)]}
    newpass
  end
  
  def self.new(group_id,person_id,checkin_type_id)
    @attendance = Attendance.new(:meeting_id => group_id, :person_id => person_id, :checkin_type_id => checkin_type_id)
    @attendance.save
  end
  
end