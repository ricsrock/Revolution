class CreateInvolvements < ActiveRecord::Migration
  def self.up
    create_table :involvements do |t|
      t.column :person_id, :integer
      t.column :job_id, :integer
    end
  end

  def self.down
    drop_table :involvements
  end
end
