class Checkin < ActiveRecord::Base
  
  ALPHA_KEYBOARD = [["",1],["Q", 3],["W",3],["E",3],["R",3],["T",3],["Y",3],["U",3],["I",3],["O",3],["P",3],["Backspace",7],
                    ["",2],["A",3],["S",3],["D",3],["F",3],["G",3],["H",3],["J",3],["K",3],["L",3],["",10.6],
                    ["",4],["Z",3],["X",3],["C",3],["V",3],["B",3],["N",3],["M",3],["Clear",17.7]
    ]
    
  NUM_PAD = [
      ["1",3],["2",3],["3",3],
      ["4",3],["5",3],["6",3],
      ["7",3],["8",3],["9",3],
      ["",3],["0",3],["<",3]
    ]
  
  
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