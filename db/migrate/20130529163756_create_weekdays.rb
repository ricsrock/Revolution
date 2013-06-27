class CreateWeekdays < ActiveRecord::Migration
  def change
    create_table :weekdays do |t|
      t.string :name

      t.timestamps
    end
    add_index :weekdays, :name
    
    days = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
    days.each do |d|
      w = Weekday.new(name: d)
      w.save
    end
  end
end