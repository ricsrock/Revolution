class CreateJobRequirements < ActiveRecord::Migration
  def self.up
    create_table :job_requirements do |t|
      t.column :job_id, :integer
      t.column :requirement_id, :integer
    end
  end

  def self.down
    drop_table :job_requirements
  end
end
