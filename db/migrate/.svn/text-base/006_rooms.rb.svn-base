class Rooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
      t.column :name, :string
      t.column :number, :integer
      t.column :capacity, :integer
    end
  end

  def self.down
    drop_table :rooms
  end
end
