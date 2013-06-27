class SetupSmartGroups < ActiveRecord::Migration
  def change
    SmartGroup.destroy_all
    Operator.destroy_all
    SmartGroupProperty.destroy_all
    
    #create operators...
    operators = [
        { short: 'after',   prose: 'after this many weeks ago'},
        { short: 'before',  prose: 'before this many weeks ago'},
        { short: 'between', prose: 'between'},
        { short: 'between', prose: 'between the following range of weeks'},
        { short: 'exactly', prose: 'exactly'},
        { short: 'greater', prose: 'greater than'},
        { short: 'less',    prose: 'less than'},
        { short: 'greater', prose: 'older than'},
        { short: 'between', prose: 'within this range of weeks'},
        { short: 'less',    prose: 'younger than'},
        { short: 'matches', prose: 'any part matches'}
      ]
      
    operators.each do |attributes|
      o = Operator.new(attributes)
      o.save
    end
      
    properties = [
        { short: 'age', prose: 'whose age is', instructions: 'enter a number'},
        { short: 'attendance_status', prose: 'whose attendance status is', instructions: 'select'},
        { short: 'birthday', prose: 'whose birthday is this many months from now', instructions: '0 for this month, 1 for next month, etc...'},
        { short: 'connected', prose: 'who are connected', instructions: 'type true to return people who are either enrolled in any group or involved with any team; type false to find people who are neither'},
        { short: 'contr_count', prose: 'whose total number of contributions is', instructions: 'type a number or a range'},
        { short: 'created_date', prose: 'whose record was created', instructions: "enter a number or a range like,'2 and 6'"},
        { short: 'enrolled', prose: 'who are enrolled in any group', instructions: 'true or false'},
        { short: 'exclusive_tags', prose: 'who are tagged with', instructions: "comma-separated values work like 'AND'"},
        { short: 'first_attend', prose: 'whose first attend was', instructions: "enter a number or a range like, '2 and 4'"},
        { short: 'first_group_attend', prose: 'whose first group attend for', instructions: "choose a group then enter a number of weeks or a range like, '1 and 3'"},
        { short: 'gender', prose: 'whose gender is', instructions: "male or female"},
        { short: 'group_count', prose: 'whose total group attends for', instructions: "select and group, an operator, then enter a number of attends"},
        { short: 'have_group', prose: 'who are enrolled in group', instructions: "comma-separated group names work like 'OR'"},
        { short: 'have_tag', prose: 'who are tagged with', instructions: "comma-separated tag names work like 'OR'"},
        { short: 'household_position', prose: 'whose household position is', instructions: "comma-separated positon names work like 'OR'"},
        { short: 'involved', prose: 'who are involved with any ministry team', instructions: "true or false"},
        { short: 'mapped', prose: 'whose household address is mapped', instructions: "true or false"},
        { short: 'not_have_tag', prose: 'who are NOT tagged with', instructions: "enter one tag name"},
        { short: 'picture', prose: "who have a picture", instructions: "true or false"},
        { short: 'recent_attend', prose: "whose most recent attend was", instructions: "enter a number of weeks or a range like, '0 and 4'"},
        { short: 'recent_contr', prose: "whose most recent contribution was", instructions: nil},
        { short: 'recent_group_attend', prose: "whose most recent group attend for", instructions: "choose a group then enter a number of weeks or a range like, '1 and 3'"},
        { short: 'total_attends', prose: "whose total attends is", instructions: nil},
        { short: 'zip', prose: "whose household zip code is", instructions: "comma-separated zip code values work like 'OR'"}
      ]
      
      properties.each do |p|
        s = SmartGroupProperty.new(p)
        s.save
      end
    
  end
end
