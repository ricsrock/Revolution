class People < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.column :household_id, :integer
      t.column :last_name, :string
      t.column :first_name, :string
      t.column :gender, :string
      t.column :birthdate, :date
      t.column :household_position, :string
      t.column :allergies, :text
    end
  end

  def self.down
    drop_table :people
  end
end
