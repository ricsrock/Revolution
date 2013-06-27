class FixGroups < ActiveRecord::Migration
  def change
    parents = Group.all_parents
    parents.each do |parent|
      puts "converting #{parent.name}"
      FixGroups.convert_this_group(parent)
    end
  end
  
  def self.convert_this_group(parent)
    if parent.convert!('Branch')
      puts "#{parent.name} converted to Branch"
      true
    else
      FixGroups.move_this_groups_enrollments(parent)
    end
  end
  
  def self.move_this_groups_enrollments(parent)
    first_child = parent.children.first
    if first_child
      puts "moving #{parent.name}'s enrollments to #{first_child.name}"
      parent.move_enrollments_to(first_child)
      parent.enrollments(true)
      FixGroups.convert_this_group(parent)
    else
      puts "#{parent.name} doesn't have any children... moving on"
    end
  end
  
end
