class AddAttributedToStamp < ActiveRecord::Migration
  def self.up
        add_column :contacts, :stamp, :string
  end

  def self.down
        remove_column :contacts, :stamp
  end
end
