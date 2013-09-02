class FixAttendCountNils < ActiveRecord::Migration
  def change
    Person.where('attend_count IS NULL').update_all(attend_count: 0)
  end
end
