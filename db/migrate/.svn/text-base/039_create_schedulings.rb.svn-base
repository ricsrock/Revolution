class CreateSchedulings < ActiveRecord::Migration
  def self.up
    create_table :schedulings do |t|
      t.column :involvement_id, :integer
      t.column :meeting_id, :integer
    end
  end

  def self.down
    drop_table :schedulings
  end
end
