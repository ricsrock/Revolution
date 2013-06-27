class ChangeActionToAbility < ActiveRecord::Migration
  def change
    rename_column :permissions, :action, :ability
  end
end
