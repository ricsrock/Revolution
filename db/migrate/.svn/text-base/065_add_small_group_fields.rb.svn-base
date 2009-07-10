class AddSmallGroupFields < ActiveRecord::Migration
  def self.up
    add_column :groups, :curriculum_choice_id, :integer
    add_column :groups, :curriculum_cost_id, :integer
    add_column :groups, :special_requirement_id, :integer
    add_column :groups, :meeting_cadence_id, :integer
    add_column :groups, :meeting_place_id, :integer
    add_column :groups, :attendance_requirement_id, :integer
    add_column :groups, :is_childcare_provided_id, :integer
    add_column :groups, :closed, :boolean, :default => false
    add_column :groups, :small_group_leader_id, :integer
    add_column :groups, :staff_person_responsible_id, :integer
    add_column :groups, :responsible_person_id, :integer
    add_column :groups, :active, :boolean, :default => true
  end

  def self.down
    remove_column :groups, :curriculum_choice_id
    remove_column :groups, :curriculum_cost
    remove_column :table_name, :column_name
    remove_column :groups, :special_requirement_id
    remove_column :groups, :meeting_cadence_id
    remove_column :groups, :meeting_place_id
    remove_column :groups, :attendance_requirement_id
    remove_column :groups, :is_childcare_provided_id
    remove_column :groups, :closed
    remove_column :groups, :small_group_leader_id
    remove_column :groups, :staff_person_responsible_i
    remove_column :groups, :responsible_person
    remove_column :groups, :active
  end
end
