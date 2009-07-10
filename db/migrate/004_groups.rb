class Groups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.column :name, :string
      t.column :default_room_id, :integer
      t.column :auto_create, :boolean
      t.column :staff_ratio, :integer
      t.column :meeting_is_called, :string
    end
  end

  def self.down
    drop_table :groups
  end
end
