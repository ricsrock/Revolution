class AddDefaultFollowUpTypeToContactTypes < ActiveRecord::Migration
  def change
    add_column :contact_types, :default_follow_up_type_id, :integer
    add_index :contact_types, :default_follow_up_type_id
  end
end