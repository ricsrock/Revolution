class ChangeAbilityToAbilityName < ActiveRecord::Migration
  def change
    rename_column :permissions, :ability, :ability_name
  end
end
