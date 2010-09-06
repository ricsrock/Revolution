class AddEstimatedBirthdayToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :estimated_birthdate, :date
  end

  def self.down
    remove_column :people, :estimated_birthdate
  end
end
