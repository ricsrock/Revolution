class ChangeToIdsToRecipientIds < ActiveRecord::Migration
  def change
    rename_column :messages, :to_ids, :recipient_ids
  end
end