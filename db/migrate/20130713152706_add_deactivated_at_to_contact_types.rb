class AddDeactivatedAtToContactTypes < ActiveRecord::Migration
  def change
    add_column :contact_types, :deactivated_at, :datetime
    add_index :contact_types, :deactivated_at
  end
end