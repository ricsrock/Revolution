class ChangeNotify < ActiveRecord::Migration
  def self.up
        rename_column :contact_types, :notify, :notiphy
  end

  def self.down
        rename_column :contact_types, :notiphy, :notify
  end
end
