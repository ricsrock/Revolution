class ConnectPropertiesAndOperators < ActiveRecord::Migration
  def change
    after_this_many_weeks = Operator.find_by_prose('after this many weeks ago')
    before_this_many_weeks = Operator.find_by_prose('before this many weeks ago')
    between = Operator.find_by_prose('between')
    between_range = Operator.find_by_prose('between the following range of weeks')
    exactly = Operator.find_by_prose('exactly')
    greater_than = Operator.find_by_prose('greater than')
    less_than = Operator.find_by_prose('less than')
    older_than = Operator.find_by_prose('older than')
    within_this_range_of_weeks = Operator.find_by_prose('within this range of weeks')
    younger_than = Operator.find_by_prose('younger than')
    matches = Operator.find_by_prose('any part matches')
    
    [older_than, exactly, younger_than].each do |v|
      property('age').operators << v
    end
    
    [before_this_many_weeks, after_this_many_weeks, between_range].each do |o|
      property('first_attend').operators << o
      property('first_group_attend').operators << o
      property('recent_group_attend').operators << o
      property('recent_attend').operators << o
      property('recent_contr').operators << o
      property('created_date').operators << o
    end
    
    [greater_than, less_than, exactly, between].each do |p|
      property('total_attends').operators << p
      property('group_count').operators << p
      property('contr_count').operators << p
    end
    
  end
  
  def property(short)
    SmartGroupProperty.find_by_short(short)
  end
end
