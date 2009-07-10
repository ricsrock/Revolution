class AddRealDateMeetings < ActiveRecord::Migration
  def self.up
    add_column :meetings, :real_date, :datetime
    add_column :meetings, :comments, :text
  end

  def self.down
    remove_column :meetings, :real_date
    remove_column :meetings, :comments
  end
end
