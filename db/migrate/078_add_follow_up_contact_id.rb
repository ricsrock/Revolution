class AddFollowUpContactId < ActiveRecord::Migration
  def self.up
    add_column :follow_ups, :contact_id, :integer
  end

  def self.down
  end
end
