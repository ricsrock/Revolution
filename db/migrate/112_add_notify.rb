class AddNotify < ActiveRecord::Migration
  def self.up
        add_column :contact_types, :notify, :boolean, :default => false
  end

  def self.down
        remove_column :contact_types, :notify
  end
end
