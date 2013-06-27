class ChangeBackToRecipients < ActiveRecord::Migration
  def change
    rename_column :messages, :to, :recipients
  end
end