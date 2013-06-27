class MakePersonBooleansDefaultToFalse < ActiveRecord::Migration
  def change
    change_column :people, :has_a_picture, :boolean, default: false
    change_column :people, :enrolled, :boolean, default: false
    change_column :people, :involved, :boolean, default: false
    change_column :people, :connected, :boolean, default: false
    
    Person.all.each do |person|
      person.update_attribute(:has_a_picture, false) unless person.has_a_picture == true
      person.update_attribute(:enrolled, false) unless person.enrolled == true
      person.update_attribute(:involved, false) unless person.involved == true
      person.update_attribute(:connected, false) unless person.connected == true
    end
  end
end