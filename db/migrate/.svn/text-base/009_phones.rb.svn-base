class Phones < ActiveRecord::Migration
  def self.up
    create_table :phones do |t|
      t.column :household_id, :integer
      t.column :person_id, :integer
      t.column :number, :string
    end
  end

  def self.down
    drop_table :phones
  end
end
