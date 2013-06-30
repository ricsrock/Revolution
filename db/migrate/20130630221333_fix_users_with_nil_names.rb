class FixUsersWithNilNames < ActiveRecord::Migration
  def change
    users = User.where('first_name IS NULL')
    users.each {|u| u.update_attribute(:first_name, '_')}
    
    users = User.where('last_name IS NULL')
    users.each {|u| u.update_attribute(:last_name, '_')}
    
  end
end
