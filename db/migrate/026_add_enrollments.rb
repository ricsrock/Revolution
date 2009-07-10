class AddEnrollments < ActiveRecord::Migration
  def self.up
    create_table :enrollments do |t|
      t.column :person_id, :integer
      t.column :group_id, :integer
      t.column :enrolled_as_id, :integer
    end
  end

  def self.down
    drop_table :enrollments
  end
end
