class RebuildGroupsTreeAgain < ActiveRecord::Migration
  def change
    Group.rebuild!
  end
end
