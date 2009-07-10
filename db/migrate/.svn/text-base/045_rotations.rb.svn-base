class Rotations < ActiveRecord::Migration
  def self.up
    create_table :rotations do |t|
      t.column :name, :string
      t.column :team_id, :integer
      t.column :weeks_on, :integer
      t.column :weeks_off, :integer
    end
  end

  def self.down
    drop_table :rotations
  end
end
