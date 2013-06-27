class GroupsCheckinGroupShouldDefaultTo0 < ActiveRecord::Migration
  def change
    change_column :groups, :checkin_group, :boolean, default: 0    
  end
end