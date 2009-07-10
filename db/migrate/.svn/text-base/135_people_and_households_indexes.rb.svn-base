class PeopleAndHouseholdsIndexes < ActiveRecord::Migration
  def self.up
    add_index :people, :first_name
    add_index :people, :last_name
    
    add_index :households, :name
    add_index :households, :address1
    add_index :households, :address2
    add_index :households, :zip
    add_index :households, :lat
    add_index :households, :lng
  end

  def self.down
  end
end
