class Initial < ActiveRecord::Migration
  def self.up
    
    create_table "adjectives" do |t|
      t.column "name",       :string
      t.column "updated_at", :datetime
      t.column "created_at", :datetime
      t.column "created_by", :string
      t.column "updated_by", :string
    end

    create_table "animals" do |t|
      t.column "name",       :string
      t.column "updated_at", :datetime
      t.column "created_at", :datetime
      t.column "created_by", :string
      t.column "updated_by", :string
    end

    create_table "assignments" do |t|
      t.column "involvement_id", :integer
      t.column "meeting_id",     :integer
    end

    add_index "assignments", ["involvement_id"], :name => "index_assignments_on_involvement_id"
    add_index "assignments", ["meeting_id"], :name => "index_assignments_on_meeting_id"

    create_table "attendance_trackers" do |t|
      t.column "person_id",          :integer
      t.column "group_id",           :integer
      t.column "most_recent_attend", :datetime
      t.column "first_attend",       :datetime
      t.column "count",              :integer
    end

    add_index "attendance_trackers", ["person_id"], :name => "index_attendance_trackers_on_person_id"
    add_index "attendance_trackers", ["group_id"], :name => "index_attendance_trackers_on_group_id"
    add_index "attendance_trackers", ["most_recent_attend"], :name => "index_attendance_trackers_on_most_recent_attend"
    add_index "attendance_trackers", ["first_attend"], :name => "index_attendance_trackers_on_first_attend"
    add_index "attendance_trackers", ["count"], :name => "index_attendance_trackers_on_count"

    create_table "attendances" do |t|
      t.column "person_id",       :integer
      t.column "meeting_id",      :integer
      t.column "checkin_time",    :datetime
      t.column "checkout_time",   :datetime
      t.column "checkin_type_id", :integer
      t.column "security_code",   :string
      t.column "call_number",     :string
    end

    add_index "attendances", ["person_id"], :name => "index_attendances_on_person_id"
    add_index "attendances", ["meeting_id"], :name => "index_attendances_on_meeting_id"

    create_table "audits" do |t|
      t.column "auditable_id",   :integer
      t.column "auditable_type", :string
      t.column "user_id",        :integer
      t.column "user_type",      :string
      t.column "username",       :string
      t.column "action",         :string
      t.column "changes",        :text
      t.column "version",        :integer,  :default => 0
      t.column "created_at",     :datetime
    end

    add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
    add_index "audits", ["user_id", "user_type"], :name => "user_index"
    add_index "audits", ["created_at"], :name => "index_audits_on_created_at"

    create_table "auto_groups" do |t|
      t.column "instance_type_id", :integer
      t.column "group_id",         :integer
    end

    create_table "auto_instance_types" do |t|
      t.column "event_type_id",    :integer
      t.column "instance_type_id", :integer
    end

    create_table "batches" do |t|
      t.column "created_at",        :datetime
      t.column "updated_at",        :datetime
      t.column "created_by",        :string
      t.column "updated_by",        :string
      t.column "comments",          :text
      t.column "date_collected",    :datetime
      t.column "count_total",       :decimal,  :precision => 9, :scale => 2
      t.column "contributions_num", :integer
      t.column "locked",            :boolean,                                :default => false
      t.column "deleted_at",        :datetime
      t.column "loose_cash",        :decimal,  :precision => 9, :scale => 2
    end

    add_index "batches", ["deleted_at"], :name => "index_batches_on_deleted_at"
    add_index "batches", ["created_at"], :name => "index_batches_on_created_at"
    add_index "batches", ["date_collected"], :name => "index_batches_on_date_collected"

    create_table "checkin_types" do |t|
      t.column "name", :string
    end

    create_table "colors" do |t|
      t.column "name",       :string
      t.column "updated_at", :datetime
      t.column "created_at", :datetime
      t.column "created_by", :string
      t.column "updated_by", :string
    end

    create_table "comm_types" do |t|
      t.column "name", :string
    end

    create_table "contact_forms" do |t|
      t.column "name",       :string
      t.column "created_by", :string
      t.column "updated_by", :string
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end

    create_table "contact_forms_contact_types", :id => false do |t|
      t.column "contact_form_id", :integer
      t.column "contact_type_id", :integer
    end

    add_index "contact_forms_contact_types", ["contact_form_id"], :name => "index_contact_forms_contact_types_on_contact_form_id"
    add_index "contact_forms_contact_types", ["contact_type_id"], :name => "index_contact_forms_contact_types_on_contact_type_id"

    create_table "contact_types" do |t|
      t.column "name",                            :string
      t.column "default_responsible_user_id",     :integer
      t.column "default_responsible_ministry_id", :integer
      t.column "created_at",                      :datetime
      t.column "updated_at",                      :datetime
      t.column "created_by",                      :string
      t.column "updated_by",                      :string
      t.column "multiple_close",                  :boolean,  :default => false
      t.column "notiphy",                         :boolean
    end

    create_table "contacts" do |t|
      t.column "contact_type_id",         :integer
      t.column "responsible_user_id",     :integer
      t.column "responsible_ministry_id", :integer
      t.column "person_id",               :integer
      t.column "household_id",            :integer
      t.column "start_date",              :datetime
      t.column "end_date",                :datetime
      t.column "comments",                :text
      t.column "created_at",              :datetime
      t.column "updated_at",              :datetime
      t.column "created_by",              :string
      t.column "updated_by",              :string
      t.column "openn",                   :boolean,  :default => true
      t.column "closed_at",               :datetime
      t.column "deleted_at",              :datetime
      t.column "stamp",                   :string
      t.column "reopen_at",               :datetime
    end

    add_index "contacts", ["created_by"], :name => "index_contacts_on_created_by"
    add_index "contacts", ["stamp"], :name => "index_contacts_on_stamp"
    add_index "contacts", ["responsible_user_id"], :name => "index_contacts_on_responsible_user_id"
    add_index "contacts", ["created_at"], :name => "index_contacts_on_created_at"
    add_index "contacts", ["person_id"], :name => "index_contacts_on_person_id"
    add_index "contacts", ["household_id"], :name => "index_contacts_on_household_id"
    add_index "contacts", ["contact_type_id"], :name => "index_contacts_on_contact_type_id"
    add_index "contacts", ["closed_at"], :name => "index_contacts_on_closed_at"
    add_index "contacts", ["reopen_at"], :name => "index_contacts_on_reopen_at"
    add_index "contacts", ["deleted_at"], :name => "index_contacts_on_deleted_at"

    create_table "contributions" do |t|
      t.column "total",      :decimal,  :precision => 9, :scale => 2
      t.column "batch_id",   :integer
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "created_by", :string
      t.column "updated_by", :string
      t.column "comments",   :text
      t.column "check_num",  :integer
      t.column "date",       :datetime
      t.column "person_id",  :integer
      t.column "deleted_at", :datetime
    end

    add_index "contributions", ["batch_id"], :name => "index_contributions_on_batch_id"
    add_index "contributions", ["person_id"], :name => "index_contributions_on_person_id"
    add_index "contributions", ["deleted_at"], :name => "index_contributions_on_deleted_at"
    add_index "contributions", ["created_at"], :name => "index_contributions_on_created_at"

    create_table "departments" do |t|
      t.column "responsible_person_id",    :integer
      t.column "responsible_person_title", :string
      t.column "purpose",                  :text
      t.column "win",                      :text
      t.column "name",                     :string
      t.column "updated_by",               :string
      t.column "created_by",               :string
      t.column "created_at",               :datetime
      t.column "updated_at",               :datetime
      t.column "deleted_at",               :datetime
    end

    create_table "deployments" do |t|
      t.column "rotation_id",    :integer
      t.column "involvement_id", :integer
    end

    add_index "deployments", ["rotation_id"], :name => "index_deployments_on_rotation_id"
    add_index "deployments", ["involvement_id"], :name => "index_deployments_on_involvement_id"

    create_table "donations" do |t|
      t.column "created_at",      :datetime
      t.column "updated_at",      :datetime
      t.column "created_by",      :string
      t.column "updated_by",      :string
      t.column "comments",        :text
      t.column "contribution_id", :integer
      t.column "amount",          :decimal,  :precision => 9, :scale => 2
      t.column "fund_id",         :integer
    end

    add_index "donations", ["contribution_id"], :name => "index_donations_on_contribution_id"
    add_index "donations", ["fund_id"], :name => "index_donations_on_fund_id"
    add_index "donations", ["created_at"], :name => "index_donations_on_created_at"

    create_table "emails" do |t|
      t.column "person_id",      :integer
      t.column "household_id",   :integer
      t.column "email",          :string
      t.column "emailable_id",   :integer
      t.column "emailable_type", :string
      t.column "comments",       :string
      t.column "primary",        :boolean
      t.column "comm_type_id",   :integer
      t.column "created_at",     :datetime, :default => '2007-12-05 22:14:28'
      t.column "updated_at",     :datetime, :default => '2007-12-05 22:29:02'
    end

    add_index "emails", ["email"], :name => "index_emails_on_email"
    add_index "emails", ["emailable_id", "emailable_type"], :name => "emailable_index"

    create_table "enrollments" do |t|
      t.column "person_id",      :integer
      t.column "group_id",       :integer
      t.column "enrolled_as_id", :integer
      t.column "start_date",     :date
      t.column "end_date",       :date
      t.column "start_time",     :datetime
      t.column "end_time",       :datetime
    end

    add_index "enrollments", ["person_id"], :name => "index_enrollments_on_person_id"
    add_index "enrollments", ["group_id"], :name => "index_enrollments_on_group_id"
    add_index "enrollments", ["start_time"], :name => "index_enrollments_on_start_time"
    add_index "enrollments", ["end_time"], :name => "index_enrollments_on_end_time"

    create_table "event_types" do |t|
      t.column "name", :string
    end

    create_table "events" do |t|
      t.column "event_type_id", :integer
      t.column "date",          :date
      t.column "name",          :string
      t.column "total_count",   :integer
      t.column "deleted_at",    :datetime
      t.column "created_by",    :string
      t.column "updated_by",    :string
      t.column "created_at",    :datetime
      t.column "updated_at",    :datetime
    end

    add_index "events", ["date"], :name => "index_events_on_date"
    add_index "events", ["event_type_id"], :name => "index_events_on_event_type_id"
    add_index "events", ["deleted_at"], :name => "index_events_on_deleted_at"

    create_table "follow_up_types", :force => true do |t|
      t.column "name", :string
    end

    create_table "follow_ups" do |t|
      t.column "notes",             :text
      t.column "created_by",        :string
      t.column "updated_by",        :string
      t.column "created_at",        :datetime
      t.column "updated_at",        :datetime
      t.column "follow_up_type_id", :integer
      t.column "contact_id",        :integer
    end

    add_index "follow_ups", ["contact_id"], :name => "index_follow_ups_on_contact_id"
    add_index "follow_ups", ["created_at"], :name => "index_follow_ups_on_created_at"
    add_index "follow_ups", ["created_by"], :name => "index_follow_ups_on_created_by"

    create_table "funds" do |t|
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "created_by", :string
      t.column "updated_by", :string
      t.column "comments",   :text
      t.column "name",       :string
    end

    create_table "group_choices" do |t|
      t.column "type", :string
      t.column "name", :string
    end

    add_index "group_choices", ["type"], :name => "index_group_choices_on_type"

    create_table "groups" do |t|
      t.column "name",                        :string
      t.column "default_room_id",             :integer
      t.column "staff_ratio",                 :integer
      t.column "meeting_is_called",           :string
      t.column "checkin_group",               :boolean
      t.column "created_at",                  :datetime,                    :null => false
      t.column "updated_at",                  :datetime,                    :null => false
      t.column "parent_id",                   :integer
      t.column "lft",                         :integer,                     :null => false
      t.column "rgt",                         :integer,                     :null => false
      t.column "created_by",                  :string
      t.column "updated_by",                  :string
      t.column "curriculum_choice_id",        :integer
      t.column "curriculum_cost_id",          :integer
      t.column "special_requirement_id",      :integer
      t.column "meeting_cadence_id",          :integer
      t.column "meeting_place_id",            :integer
      t.column "attendance_requirement_id",   :integer
      t.column "is_childcare_provided_id",    :integer
      t.column "closed",                      :boolean,  :default => false
      t.column "small_group_leader_id",       :integer
      t.column "staff_person_responsible_id", :integer
      t.column "responsible_person_id",       :integer
      t.column "active",                      :boolean,  :default => true
      t.column "meets_at_household_id",       :integer
      t.column "leader_name_for_printing_id", :integer
      t.column "blurb",                       :text
      t.column "meets_on",                    :string
      t.column "time_from",                   :time
      t.column "time_until",                  :time
      t.column "show_on_web",                 :boolean,  :default => false
      t.column "deleted_at",                  :datetime
      t.column "archived_on",                 :datetime
      t.column "tree_id",                     :integer
    end

    add_index "groups", ["name"], :name => "index_groups_on_name"
    add_index "groups", ["parent_id"], :name => "index_groups_on_parent_id"
    add_index "groups", ["lft"], :name => "index_groups_on_lft"
    add_index "groups", ["rgt"], :name => "index_groups_on_rgt"
    add_index "groups", ["deleted_at"], :name => "index_groups_on_deleted_at"
    add_index "groups", ["tree_id"], :name => "index_groups_on_tree_id"
    add_index "groups", ["small_group_leader_id"], :name => "index_groups_on_small_group_leader_id"
    add_index "groups", ["staff_person_responsible_id"], :name => "index_groups_on_staff_person_responsible_id"
    add_index "groups", ["responsible_person_id"], :name => "index_groups_on_responsible_person_id"
    add_index "groups", ["show_on_web"], :name => "index_groups_on_show_on_web"
    add_index "groups", ["active"], :name => "index_groups_on_active"
    add_index "groups", ["archived_on"], :name => "index_groups_on_archived_on"

    create_table "groups_web_categories", :id => false do |t|
      t.column "group_id",        :integer
      t.column "web_category_id", :integer
    end

    add_index "groups_web_categories", ["group_id"], :name => "group_id"
    add_index "groups_web_categories", ["web_category_id"], :name => "web_category_id"

    create_table "households" do |t|
      t.column "name",                :string
      t.column "address1",            :string
      t.column "address2",            :string
      t.column "city",                :string
      t.column "state",               :string
      t.column "zip",                 :integer
      t.column "created_at",          :datetime
      t.column "updated_at",          :datetime
      t.column "created_by",          :string
      t.column "updated_by",          :string
      t.column "attendance_status",   :string
      t.column "contribution_status", :string
      t.column "attend_count",        :integer
      t.column "deleted_at",          :datetime
      t.column "address",             :string
      t.column "lat",                 :decimal,  :precision => 15, :scale => 10
      t.column "lng",                 :decimal,  :precision => 15, :scale => 10
    end

    add_index "households", ["name"], :name => "index_households_on_name"
    add_index "households", ["address1"], :name => "index_households_on_address1"
    add_index "households", ["address2"], :name => "index_households_on_address2"
    add_index "households", ["zip"], :name => "index_households_on_zip"
    add_index "households", ["lat"], :name => "index_households_on_lat"
    add_index "households", ["lng"], :name => "index_households_on_lng"
    add_index "households", ["deleted_at"], :name => "index_households_on_deleted_at"

    create_table "instance_types" do |t|
      t.column "name", :string
    end

    create_table "instances" do |t|
      t.column "instance_type_id", :integer
      t.column "event_id",         :integer
      t.column "car_count",        :integer
      t.column "total_count",      :integer
      t.column "deleted_at",       :datetime
    end

    add_index "instances", ["event_id"], :name => "index_instances_on_event_id"
    add_index "instances", ["deleted_at"], :name => "index_instances_on_deleted_at"
    add_index "instances", ["instance_type_id"], :name => "index_instances_on_instance_type_id"

    create_table "involvements" do |t|
      t.column "person_id",  :integer
      t.column "job_id",     :integer
      t.column "created_at", :datetime, :default => '2007-12-05 22:14:28'
      t.column "updated_at", :datetime, :default => '2007-12-05 22:14:28'
      t.column "deleted_at", :datetime
      t.column "start_date", :date
      t.column "end_date",   :date
    end

    add_index "involvements", ["person_id"], :name => "index_involvements_on_person_id"
    add_index "involvements", ["job_id"], :name => "index_involvements_on_job_id"
    add_index "involvements", ["start_date"], :name => "index_involvements_on_start_date"
    add_index "involvements", ["end_date"], :name => "index_involvements_on_end_date"

    create_table "job_requirements" do |t|
      t.column "job_id",         :integer
      t.column "requirement_id", :integer
    end

    create_table "jobs" do |t|
      t.column "title",             :string
      t.column "contact_person_id", :integer
      t.column "cadence",           :text
      t.column "description",       :text
      t.column "tasks",             :text
      t.column "team_id",           :integer
      t.column "created_at",        :datetime, :default => '2007-12-05 22:29:03'
      t.column "updated_at",        :datetime, :default => '2007-12-05 22:29:03'
      t.column "created_by",        :string
      t.column "updated_by",        :string
      t.column "deleted_at",        :datetime
    end

    add_index "jobs", ["title"], :name => "index_jobs_on_title"
    add_index "jobs", ["team_id"], :name => "index_jobs_on_team_id"
    add_index "jobs", ["deleted_at"], :name => "index_jobs_on_deleted_at"

    create_table "meetings" do |t|
      t.column "instance_id",        :integer
      t.column "group_id",           :integer
      t.column "room_id",            :integer
      t.column "real_date",          :datetime
      t.column "comments",           :text
      t.column "leaders_count",      :integer,  :default => 0
      t.column "participants_count", :integer,  :default => 0
      t.column "total_count",        :integer,  :default => 0
      t.column "deleted_at",         :datetime
      t.column "created_by",         :string
      t.column "updated_by",         :string
      t.column "created_at",         :datetime
      t.column "updated_at",         :datetime
      t.column "num_marked",         :integer
    end

    add_index "meetings", ["group_id"], :name => "index_meetings_on_group_id"
    add_index "meetings", ["instance_id"], :name => "index_meetings_on_instance_id"
    add_index "meetings", ["deleted_at"], :name => "index_meetings_on_deleted_at"

    create_table "milestones" do |t|
      t.column "person_id",      :integer
      t.column "requirement_id", :integer
      t.column "start_date",     :date
      t.column "end_date",       :date
      t.column "comments",       :text
      t.column "created_by",     :string
      t.column "updated_by",     :string
    end

    create_table "ministries" do |t|
      t.column "responsible_person_id",    :integer
      t.column "responsible_person_title", :string
      t.column "purpose",                  :text
      t.column "win",                      :text
      t.column "name",                     :string
      t.column "department_id",            :integer
      t.column "created_at",               :datetime, :default => '2007-12-05 22:29:03'
      t.column "updated_at",               :datetime, :default => '2007-12-05 22:29:03'
      t.column "created_by",               :string
      t.column "updated_by",               :string
      t.column "deleted_at",               :datetime
    end

    add_index "ministries", ["responsible_person_id"], :name => "index_ministries_on_responsible_person_id"
    add_index "ministries", ["department_id"], :name => "index_ministries_on_department_id"
    add_index "ministries", ["deleted_at"], :name => "index_ministries_on_deleted_at"

    create_table "ministries_users", :id => false do |t|
      t.column "ministry_id", :integer
      t.column "user_id",     :integer
    end

    add_index "ministries_users", ["ministry_id"], :name => "index_ministries_users_on_ministry_id"
    add_index "ministries_users", ["user_id"], :name => "index_ministries_users_on_user_id"

    create_table "my_colors" do |t|
      t.column "name",       :string
      t.column "updated_at", :datetime
      t.column "created_at", :datetime
      t.column "created_by", :string
      t.column "updated_by", :string
    end

    create_table "note_types" do |t|
      t.column "name",       :string
      t.column "created_by", :string
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "updated_by", :string
    end

    create_table "notes" do |t|
      t.column "type_id",       :integer
      t.column "text",          :text
      t.column "created_by",    :string
      t.column "updated_by",    :string
      t.column "updated_at",    :datetime
      t.column "noteable_id",   :integer
      t.column "noteable_type", :string
      t.column "created_at",    :datetime
      t.column "confidential",  :boolean
    end

    add_index "notes", ["noteable_id"], :name => "index_notes_on_noteable_id"
    add_index "notes", ["noteable_type"], :name => "index_notes_on_noteable_type"
    add_index "notes", ["type_id"], :name => "index_notes_on_type_id"

    create_table "operators" do |t|
      t.column "smart_group_property_id", :integer
      t.column "prose",                   :string
      t.column "short",                   :string
    end

    add_index "operators", ["smart_group_property_id"], :name => "index_operators_on_smart_group_property_id"

    create_table "people" do |t|
      t.column "household_id",        :integer
      t.column "last_name",           :string
      t.column "first_name",          :string
      t.column "gender",              :string
      t.column "birthdate",           :date
      t.column "household_position",  :string
      t.column "allergies",           :text
      t.column "default_group_id",    :integer
      t.column "created_by",          :string
      t.column "updated_by",          :string
      t.column "user_id",             :integer
      t.column "max_date",            :date
      t.column "attendance_status",   :string
      t.column "contribution_status", :string
      t.column "attend_count",        :integer
      t.column "deleted_at",          :datetime
      t.column "second_attend",       :datetime
      t.column "worship_attends",     :integer
      t.column "max_worship_date",    :date
      t.column "min_date",            :date
      t.column "recent_contr",        :datetime
      t.column "contr_count",         :integer
      t.column "updated_at",          :datetime
      t.column "created_at",          :datetime
    end

    add_index "people", ["first_name", "last_name"], :name => "full_name_index"
    add_index "people", ["household_id"], :name => "index_people_on_household_id"
    add_index "people", ["birthdate"], :name => "index_people_on_birthdate"
    add_index "people", ["household_position"], :name => "index_people_on_household_position"
    add_index "people", ["default_group_id"], :name => "index_people_on_default_group_id"
    add_index "people", ["attendance_status"], :name => "index_people_on_attendance_status"
    add_index "people", ["worship_attends"], :name => "index_people_on_worship_attends"
    add_index "people", ["max_worship_date"], :name => "index_people_on_max_worship_date"
    add_index "people", ["min_date"], :name => "index_people_on_min_date"
    add_index "people", ["attend_count"], :name => "index_people_on_attend_count"
    add_index "people", ["second_attend"], :name => "index_people_on_second_attend"
    add_index "people", ["first_name"], :name => "index_people_on_first_name"
    add_index "people", ["last_name"], :name => "index_people_on_last_name"
    add_index "people", ["deleted_at"], :name => "index_people_on_deleted_at"
    add_index "people", ["contr_count"], :name => "index_people_on_contr_count"
    add_index "people", ["recent_contr"], :name => "index_people_on_recent_contr"

    create_table "phones" do |t|
      t.column "household_id",  :integer
      t.column "person_id",     :integer
      t.column "number",        :string
      t.column "comments",      :string
      t.column "primary",       :boolean
      t.column "comm_type_id",  :integer
      t.column "phonable_id",   :integer
      t.column "phonable_type", :string
      t.column "created_at",    :datetime, :default => '2007-12-05 22:29:02'
      t.column "updated_at",    :datetime, :default => '2007-12-05 22:29:02'
      t.column "sms_setup_id",  :integer
    end

    add_index "phones", ["number"], :name => "index_phones_on_number"
    add_index "phones", ["phonable_id", "phonable_type"], :name => "phonable_index"

    create_table "pictures" do |t|
      t.column "person_id",    :integer
      t.column "parent_id",    :integer
      t.column "size",         :integer
      t.column "width",        :integer
      t.column "height",       :integer
      t.column "content_type", :string
      t.column "filename",     :string
      t.column "thumbnail",    :string
    end

    add_index "pictures", ["person_id"], :name => "index_pictures_on_person_id"
    add_index "pictures", ["parent_id"], :name => "index_pictures_on_parent_id"

    create_table "plugin_schema_info", :id => false do |t|
      t.column "plugin_name", :string
      t.column "version",     :integer
    end

    create_table "relationship_roles" do |t|
      t.column "name",                 :string
      t.column "relationship_type_id", :integer
      t.column "created_by",           :string
      t.column "updated_by",           :string
      t.column "created_at",           :datetime
      t.column "updated_at",           :datetime
    end

    create_table "relationship_types" do |t|
      t.column "name",       :string
      t.column "created_at", :datetime
      t.column "created_by", :string
      t.column "updated_at", :datetime
      t.column "updated_by", :string
    end

    create_table "relationships" do |t|
      t.column "relationship_type_id", :integer
      t.column "person_id",            :integer
      t.column "relates_to_id",        :integer
      t.column "person_role_id",       :integer
      t.column "relates_to_role_id",   :integer
      t.column "start_date",           :datetime
      t.column "end_date",             :datetime
      t.column "deactivated_on",       :datetime
      t.column "web_access",           :boolean
      t.column "created_by",           :string
      t.column "updated_by",           :string
      t.column "created_at",           :datetime
      t.column "updated_at",           :datetime
      t.column "comments",             :text
    end

    add_index "relationships", ["person_id"], :name => "index_relationships_on_person_id"
    add_index "relationships", ["relationship_type_id"], :name => "index_relationships_on_relationship_type_id"
    add_index "relationships", ["relates_to_id"], :name => "index_relationships_on_relates_to_id"
    add_index "relationships", ["deactivated_on"], :name => "index_relationships_on_deactivated_on"

    create_table "requirements" do |t|
      t.column "name",        :string
      t.column "description", :text
    end

    create_table "roles" do |t|
      t.column "name",        :string
      t.column "alias",       :string
      t.column "description", :text
    end

    create_table "roles_users", :id => false do |t|
      t.column "role_id", :integer
      t.column "user_id", :integer
    end

    add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
    add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

    create_table "rooms" do |t|
      t.column "name",     :string
      t.column "number",   :integer
      t.column "capacity", :integer
    end

    create_table "rotations" do |t|
      t.column "name",       :string
      t.column "team_id",    :integer
      t.column "weeks_on",   :integer
      t.column "weeks_off",  :integer
      t.column "deleted_at", :datetime
    end

    add_index "rotations", ["team_id"], :name => "index_rotations_on_team_id"

    create_table "service_links" do |t|
      t.column "group_id", :integer
      t.column "team_id",  :integer
    end

    add_index "service_links", ["team_id"], :name => "index_service_links_on_team_id"
    add_index "service_links", ["group_id"], :name => "index_service_links_on_group_id"

    create_table "sessions" do |t|
      t.column "session_id", :string
      t.column "data",       :text
      t.column "updated_at", :datetime
    end

    add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
    add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

    create_table "settings" do |t|
      t.column "current_instance",         :integer
      t.column "advance_decline_run_date", :datetime
    end

    create_table "smart_group_properties" do |t|
      t.column "prose",        :string
      t.column "short",        :string
      t.column "instructions", :text
    end

    create_table "smart_group_rules" do |t|
      t.column "smart_group_id", :integer
      t.column "content",        :string
      t.column "property_id",    :integer
      t.column "operator_id",    :integer
    end

    add_index "smart_group_rules", ["smart_group_id"], :name => "index_smart_group_rules_on_smart_group_id"

    create_table "smart_groups" do |t|
      t.column "name",       :string
      t.column "definition", :text
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "created_by", :string
      t.column "updated_by", :string
    end

    create_table "sms_setups" do |t|
      t.column "carrier_name", :string
      t.column "config",       :string
      t.column "created_at",   :datetime
      t.column "updated_at",   :datetime
      t.column "created_by",   :string
      t.column "updated_by",   :string
    end

    create_table "tag_groups" do |t|
      t.column "name",       :string
      t.column "created_at", :datetime, :default => '2007-12-06 13:37:31'
      t.column "updated_at", :datetime, :default => '2007-12-06 13:37:31'
      t.column "created_by", :string
      t.column "updated_by", :string
    end

    create_table "taggings" do |t|
      t.column "comments",   :string
      t.column "created_at", :datetime, :default => '2007-12-06 13:37:31'
      t.column "updated_at", :datetime, :default => '2007-12-06 13:37:31'
      t.column "created_by", :string
      t.column "updated_by", :string
      t.column "person_id",  :integer
      t.column "tag_id",     :integer
      t.column "start_date", :date
      t.column "end_date",   :date
    end

    add_index "taggings", ["person_id"], :name => "index_taggings_on_person_id"
    add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"

    create_table "tags" do |t|
      t.column "name",         :string
      t.column "created_at",   :datetime, :default => '2007-12-06 13:37:30'
      t.column "updated_at",   :datetime, :default => '2007-12-06 13:37:30'
      t.column "created_by",   :string
      t.column "updated_by",   :string
      t.column "tag_group_id", :integer
    end

    add_index "tags", ["name"], :name => "index_tags_on_name"
    add_index "tags", ["tag_group_id"], :name => "index_tags_on_tag_group_id"

    create_table "teams" do |t|
      t.column "responsible_person_id",    :integer
      t.column "responsible_person_title", :string
      t.column "purpose",                  :text
      t.column "win",                      :text
      t.column "name",                     :string
      t.column "ministry_id",              :integer
      t.column "created_at",               :datetime, :default => '2007-12-05 22:29:02'
      t.column "updated_at",               :datetime, :default => '2007-12-05 22:29:02'
      t.column "created_by",               :string
      t.column "updated_by",               :string
      t.column "deleted_at",               :datetime
    end

    add_index "teams", ["responsible_person_id"], :name => "index_teams_on_responsible_person_id"
    add_index "teams", ["ministry_id"], :name => "ministry_id"
    add_index "teams", ["deleted_at"], :name => "deleted_at"

    create_table "tools" do |t|
    end

    create_table "users" do |t|
      t.column "login",                     :string
      t.column "email",                     :string
      t.column "crypted_password",          :string,   :limit => 40
      t.column "salt",                      :string,   :limit => 40
      t.column "created_at",                :datetime
      t.column "updated_at",                :datetime
      t.column "remember_token",            :string
      t.column "remember_token_expires_at", :datetime
      t.column "first_name",                :string
      t.column "last_name",                 :string
      t.column "password_reset_code",       :string,   :limit => 40
      t.column "group_scope",               :string
      t.column "is_staff",                  :boolean
    end

    create_table "web_categories" do |t|
      t.column "name",       :string
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "created_by", :string
      t.column "updated_by", :string
    end
  end

  def self.down
  end
end
