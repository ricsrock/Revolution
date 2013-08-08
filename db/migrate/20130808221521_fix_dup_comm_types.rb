class FixDupCommTypes < ActiveRecord::Migration
  def change
    home = CommType.find_all_by_name('Home')
    mobile = CommType.find_all_by_name('Mobile')
    work = CommType.find_all_by_name('Work')
    
    while home.size > 1 do
      f = home.first
      l = home.last
      p = Phone.where(comm_type_id: l.id)
      p.each {|i| i.update_attribute(:comm_type_id, f.id)}
      e = Email.where(comm_type_id: l.id)
      e.each {|i| i.update_attribute(:comm_type_id, f.id)}
      l.destroy
      home = CommType.find_all_by_name('Home')
    end
    
    while mobile.size > 1 do
      f = mobile.first
      l = mobile.last
      p = Phone.where(comm_type_id: l.id)
      p.each {|i| i.update_attribute(:comm_type_id, f.id)}
      e = Email.where(comm_type_id: l.id)
      e.each {|i| i.update_attribute(:comm_type_id, f.id)}
      l.destroy
      mobile = CommType.find_all_by_name('Mobile')
    end
    
    while work.size > 1 do
      f = work.first
      l = work.last
      p = Phone.where(comm_type_id: l.id)
      p.each {|i| i.update_attribute(:comm_type_id, f.id)}
      e = Email.where(comm_type_id: l.id)
      e.each {|i| i.update_attribute(:comm_type_id, f.id)}
      l.destroy
      work = CommType.find_all_by_name('Work')
    end
  end
end
