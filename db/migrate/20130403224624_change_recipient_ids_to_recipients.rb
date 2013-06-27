class ChangeRecipientIdsToRecipients < ActiveRecord::Migration
  def change
    rename_column :messages, :recipient_ids, :recipients
  end
end