class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.column :title, :string
      t.column :contact_person_id, :integer
      t.column :cadence, :text
      t.column :description, :text
      t.column :tasks, :text
    end
  end

  def self.down
    drop_table :jobs
  end
end
