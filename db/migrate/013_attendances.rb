class Attendances < ActiveRecord::Migration
  def self.up
    create_table :attendances do |t|
      t.column :person_id, :integer
      t.column :meeting_id, :integer
      t.column :checkin_as_id, :integer
      t.column :checkin_time, :datetime
      t.column :checkout_time, :datetime
    end
  end

  def self.down
    drop_table :attendances
  end
end
