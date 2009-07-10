class Settings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.column :current_instance, :integer
    end
  end

  def self.down
    drop_table :settings
  end
end
