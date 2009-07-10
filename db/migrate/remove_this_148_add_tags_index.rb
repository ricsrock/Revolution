class AddTagsIndex < ActiveRecord::Migration
  def self.up
    add_index :tags, :name
    add_index :tags, :tag_group_id
    add_index :follow_ups, :created_by
    add_index :jobs, :title
    add_index :jobs, :team_id
    add_index :jobs, :deleted_at
    add_index :ministries, :responsible_person_id
    add_index :ministries, :department_id
    add_index :ministries, :deleted_at
    add_index :pictures, :person_id
    add_index :pictures, :parent_id
    add_index :relationships, :person_id
    add_index :relationships, :relationship_type_id
    add_index :relationships, :relates_to_id
    add_index :relationships, :deactivated_on
    add_index :groups, :small_group_leader_id
    add_index :groups, :staff_person_responsible_id
    add_index :groups, :responsible_person_id
    add_index :groups, :show_on_web
    add_index :groups, :active
    add_index :groups, :archived_on
    add_index :assignments, :involvement_id
    add_index :assignments, :meeting_id
    add_index :batches, :deleted_at
    add_index :batches, :created_at
    add_index :batches, :date_collected
    add_index :deployments, :rotation_id
    add_index :deployments, :involvement_id
    add_index :events, :date
    add_index :events, :event_type_id
    add_index :events, :deleted_at
    add_index :group_choices, :type
    add_index :instances, :event_id
    add_index :instances, :deleted_at
    add_index :instances, :instance_type_id
    add_index :operators, :smart_group_property_id
    add_index :rotations, :team_id
    add_index :service_links, :team_id
    add_index :service_links, :group_id
    add_index :smart_group_rules, :smart_group_id
    add_index :teams, :responsible_person_id
    add_index :teams, :ministry_id
    add_index :teams, :deleted_at
  end

  def self.down
  end
end
