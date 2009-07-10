class Emails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.column :person_id, :integer
      t.column :household_id, :integer
      t.column :email, :string
    end
  end

  def self.down
    drop_table :emails
  end
end
