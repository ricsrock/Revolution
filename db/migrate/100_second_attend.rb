class SecondAttend < ActiveRecord::Migration
  def self.up
        add_column :people, :second_attend, :datetime
  end

  def self.down
        remove_column :people, :second_attend
  end
end
