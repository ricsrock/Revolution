class ChangeToToToIds < ActiveRecord::Migration
  def change
    rename_column :messages, :to, :to_ids
  end
end