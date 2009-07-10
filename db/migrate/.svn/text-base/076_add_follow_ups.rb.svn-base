class AddFollowUps < ActiveRecord::Migration
  def self.up
    create_table :follow_ups do |t|
      t.column :notes, :text
      t.column :created_by, :string
      t.column :updated_by, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :follow_up_type_id, :integer
    end
  end

  def self.down
    drop_table :follow_ups
  end
end
