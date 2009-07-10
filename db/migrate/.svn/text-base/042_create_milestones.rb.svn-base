class CreateMilestones < ActiveRecord::Migration
  def self.up
    create_table :milestones do |t|
      t.column :person_id, :integer
      t.column :requirement_id, :integer
      t.column :start_date, :date
      t.column :end_date, :date
      t.column :comments, :text
      t.column :created_by, :string
      t.column :updated_by, :string
    end
  end

  def self.down
    drop_table :milestones
  end
end
