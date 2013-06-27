class ChangeBackToTo < ActiveRecord::Migration
  def change
    rename_column :messages, :recipients, :to
  end
end