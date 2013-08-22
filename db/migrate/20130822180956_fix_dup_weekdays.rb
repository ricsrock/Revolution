class FixDupWeekdays < ActiveRecord::Migration
  def change
    daynames = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
    daynames.each do |dayname|
      weekdays = Weekday.where(name: dayname)
      while weekdays.size > 1 do
        f = weekdays.first
        l = weekdays.last
        dups = MeetsOn.where(weekday_id: l.id)
        dups.each do |m| 
          m.update_attribute(:weekday_id, f.id)
          m.destroy
        end
        l.destroy
        weekdays = Weekday.where(name: dayname)
      end
    end    
  end
end
