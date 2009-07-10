class CreateVolunteerMilestones < ActiveRecord::Migration
  def self.up
    create_table :requirements do |t|
      t.column :name, :string
      t.column :description, :text
    end
  end

  def self.down
    drop_table :requirements
  end
end
