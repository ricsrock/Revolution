class Events < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
        t.column :event_type_id, :integer
        t.column :date, :date
        t.column :name, :string
    end
  end

  def self.down
    drop_table :events
  end
end
