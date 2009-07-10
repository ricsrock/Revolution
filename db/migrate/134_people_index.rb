class PeopleIndex < ActiveRecord::Migration
  def self.up
    add_index :people, [:first_name, :last_name], :name => 'full_name_index'
    add_index :people, :household_id
    add_index :people, :birthdate
    add_index :people, :household_position
    add_index :people, :default_group_id
    add_index :people, :attendance_status
    add_index :people, :worship_attends
    add_index :people, :max_worship_date
    add_index :people, :min_date
    add_index :people, :attend_count
    add_index :people, :second_attend
  end

  def self.down
  end
end
