# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090718122219) do

  create_table "adjectives", :force => true do |t|
    t.string   "name"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "created_by"
    t.string   "updated_by"
  end

  create_table "animals", :force => true do |t|
    t.string   "name"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "created_by"
    t.string   "updated_by"
  end

  create_table "assignments", :force => true do |t|
    t.integer "involvement_id"
    t.integer "meeting_id"
  end

  add_index "assignments", ["involvement_id"], :name => "index_assignments_on_involvement_id"
  add_index "assignments", ["meeting_id"], :name => "index_assignments_on_meeting_id"

  create_table "attendance_trackers", :force => true do |t|
    t.integer  "person_id"
    t.integer  "group_id"
    t.datetime "most_recent_attend"
    t.datetime "first_attend"
    t.integer  "count"
  end

  add_index "attendance_trackers", ["count"], :name => "index_attendance_trackers_on_count"
  add_index "attendance_trackers", ["first_attend"], :name => "index_attendance_trackers_on_first_attend"
  add_index "attendance_trackers", ["group_id"], :name => "index_attendance_trackers_on_group_id"
  add_index "attendance_trackers", ["most_recent_attend"], :name => "index_attendance_trackers_on_most_recent_attend"
  add_index "attendance_trackers", ["person_id"], :name => "index_attendance_trackers_on_person_id"

  create_table "attendances", :force => true do |t|
    t.integer  "person_id"
    t.integer  "meeting_id"
    t.datetime "checkin_time"
    t.datetime "checkout_time"
    t.integer  "checkin_type_id"
    t.string   "security_code"
    t.string   "call_number"
  end

  add_index "attendances", ["meeting_id"], :name => "index_attendances_on_meeting_id"
  add_index "attendances", ["person_id"], :name => "index_attendances_on_person_id"

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "changes"
    t.integer  "version",        :default => 0
    t.datetime "created_at"
  end

  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "auto_groups", :force => true do |t|
    t.integer "instance_type_id"
    t.integer "group_id"
  end

  create_table "auto_instance_types", :force => true do |t|
    t.integer "event_type_id"
    t.integer "instance_type_id"
  end

  create_table "batches", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
    t.text     "comments"
    t.datetime "date_collected"
    t.decimal  "count_total",       :precision => 9, :scale => 2
    t.integer  "contributions_num"
    t.boolean  "locked",                                          :default => false
    t.datetime "deleted_at"
    t.decimal  "loose_cash",        :precision => 9, :scale => 2
  end

  add_index "batches", ["created_at"], :name => "index_batches_on_created_at"
  add_index "batches", ["date_collected"], :name => "index_batches_on_date_collected"
  add_index "batches", ["deleted_at"], :name => "index_batches_on_deleted_at"

  create_table "checkin_types", :force => true do |t|
    t.string "name"
  end

  create_table "colors", :force => true do |t|
    t.string   "name"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "created_by"
    t.string   "updated_by"
  end

  create_table "comm_types", :force => true do |t|
    t.string "name"
  end

  create_table "contact_forms", :force => true do |t|
    t.string   "name"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_forms_contact_types", :id => false, :force => true do |t|
    t.integer "contact_form_id"
    t.integer "contact_type_id"
  end

  add_index "contact_forms_contact_types", ["contact_form_id"], :name => "index_contact_forms_contact_types_on_contact_form_id"
  add_index "contact_forms_contact_types", ["contact_type_id"], :name => "index_contact_forms_contact_types_on_contact_type_id"

  create_table "contact_types", :force => true do |t|
    t.string   "name"
    t.integer  "default_responsible_user_id"
    t.integer  "default_responsible_ministry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
    t.boolean  "multiple_close",                  :default => false
    t.boolean  "notiphy"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "contact_type_id"
    t.integer  "responsible_user_id"
    t.integer  "responsible_ministry_id"
    t.integer  "person_id"
    t.integer  "household_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
    t.boolean  "openn",                   :default => true
    t.datetime "closed_at"
    t.datetime "deleted_at"
    t.string   "stamp"
    t.datetime "reopen_at"
  end

  add_index "contacts", ["closed_at"], :name => "index_contacts_on_closed_at"
  add_index "contacts", ["contact_type_id"], :name => "index_contacts_on_contact_type_id"
  add_index "contacts", ["created_at"], :name => "index_contacts_on_created_at"
  add_index "contacts", ["created_by"], :name => "index_contacts_on_created_by"
  add_index "contacts", ["deleted_at"], :name => "index_contacts_on_deleted_at"
  add_index "contacts", ["household_id"], :name => "index_contacts_on_household_id"
  add_index "contacts", ["person_id"], :name => "index_contacts_on_person_id"
  add_index "contacts", ["reopen_at"], :name => "index_contacts_on_reopen_at"
  add_index "contacts", ["responsible_user_id"], :name => "index_contacts_on_responsible_user_id"
  add_index "contacts", ["stamp"], :name => "index_contacts_on_stamp"

  create_table "contributions", :force => true do |t|
    t.decimal  "total",      :precision => 9, :scale => 2
    t.integer  "batch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
    t.text     "comments"
    t.integer  "check_num"
    t.datetime "date"
    t.integer  "person_id"
    t.datetime "deleted_at"
  end

  add_index "contributions", ["batch_id"], :name => "index_contributions_on_batch_id"
  add_index "contributions", ["created_at"], :name => "index_contributions_on_created_at"
  add_index "contributions", ["deleted_at"], :name => "index_contributions_on_deleted_at"
  add_index "contributions", ["person_id"], :name => "index_contributions_on_person_id"

  create_table "departments", :force => true do |t|
    t.integer  "responsible_person_id"
    t.string   "responsible_person_title"
    t.text     "purpose"
    t.text     "win"
    t.string   "name"
    t.string   "updated_by"
    t.string   "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "deployments", :force => true do |t|
    t.integer "rotation_id"
    t.integer "involvement_id"
  end

  add_index "deployments", ["involvement_id"], :name => "index_deployments_on_involvement_id"
  add_index "deployments", ["rotation_id"], :name => "index_deployments_on_rotation_id"

  create_table "donations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
    t.text     "comments"
    t.integer  "contribution_id"
    t.decimal  "amount",          :precision => 9, :scale => 2
    t.integer  "fund_id"
  end

  add_index "donations", ["contribution_id"], :name => "index_donations_on_contribution_id"
  add_index "donations", ["created_at"], :name => "index_donations_on_created_at"
  add_index "donations", ["fund_id"], :name => "index_donations_on_fund_id"

  create_table "emails", :force => true do |t|
    t.integer  "person_id"
    t.integer  "household_id"
    t.string   "email"
    t.integer  "emailable_id"
    t.string   "emailable_type"
    t.string   "comments"
    t.boolean  "primary"
    t.integer  "comm_type_id"
    t.datetime "created_at",     :default => '2007-12-05 22:14:28'
    t.datetime "updated_at",     :default => '2007-12-05 22:29:02'
  end

  add_index "emails", ["email"], :name => "index_emails_on_email"
  add_index "emails", ["emailable_id", "emailable_type"], :name => "emailable_index"

  create_table "enrollments", :force => true do |t|
    t.integer  "person_id"
    t.integer  "group_id"
    t.integer  "enrolled_as_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  add_index "enrollments", ["end_time"], :name => "index_enrollments_on_end_time"
  add_index "enrollments", ["group_id"], :name => "index_enrollments_on_group_id"
  add_index "enrollments", ["person_id"], :name => "index_enrollments_on_person_id"
  add_index "enrollments", ["start_time"], :name => "index_enrollments_on_start_time"

  create_table "event_types", :force => true do |t|
    t.string "name"
  end

  create_table "events", :force => true do |t|
    t.integer  "event_type_id"
    t.date     "date"
    t.string   "name"
    t.integer  "total_count"
    t.datetime "deleted_at"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["date"], :name => "index_events_on_date"
  add_index "events", ["deleted_at"], :name => "index_events_on_deleted_at"
  add_index "events", ["event_type_id"], :name => "index_events_on_event_type_id"

  create_table "follow_up_types", :force => true do |t|
    t.string "name"
  end

  create_table "follow_ups", :force => true do |t|
    t.text     "notes"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "follow_up_type_id"
    t.integer  "contact_id"
  end

  add_index "follow_ups", ["contact_id"], :name => "index_follow_ups_on_contact_id"
  add_index "follow_ups", ["created_at"], :name => "index_follow_ups_on_created_at"
  add_index "follow_ups", ["created_by"], :name => "index_follow_ups_on_created_by"

  create_table "funds", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
    t.text     "comments"
    t.string   "name"
  end

  create_table "group_choices", :force => true do |t|
    t.string "type"
    t.string "name"
  end

  add_index "group_choices", ["type"], :name => "index_group_choices_on_type"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "default_room_id"
    t.integer  "staff_ratio"
    t.string   "meeting_is_called"
    t.boolean  "checkin_group"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.integer  "parent_id"
    t.integer  "lft",                                            :null => false
    t.integer  "rgt",                                            :null => false
    t.string   "created_by"
    t.string   "updated_by"
    t.integer  "curriculum_choice_id"
    t.integer  "curriculum_cost_id"
    t.integer  "special_requirement_id"
    t.integer  "meeting_cadence_id"
    t.integer  "meeting_place_id"
    t.integer  "attendance_requirement_id"
    t.integer  "is_childcare_provided_id"
    t.boolean  "closed",                      :default => false
    t.integer  "small_group_leader_id"
    t.integer  "staff_person_responsible_id"
    t.integer  "responsible_person_id"
    t.boolean  "active",                      :default => true
    t.integer  "meets_at_household_id"
    t.integer  "leader_name_for_printing_id"
    t.text     "blurb"
    t.string   "meets_on"
    t.time     "time_from"
    t.time     "time_until"
    t.boolean  "show_on_web",                 :default => false
    t.datetime "deleted_at"
    t.datetime "archived_on"
    t.integer  "tree_id"
  end

  add_index "groups", ["active"], :name => "index_groups_on_active"
  add_index "groups", ["archived_on"], :name => "index_groups_on_archived_on"
  add_index "groups", ["deleted_at"], :name => "index_groups_on_deleted_at"
  add_index "groups", ["lft"], :name => "index_groups_on_lft"
  add_index "groups", ["name"], :name => "index_groups_on_name"
  add_index "groups", ["parent_id"], :name => "index_groups_on_parent_id"
  add_index "groups", ["responsible_person_id"], :name => "index_groups_on_responsible_person_id"
  add_index "groups", ["rgt"], :name => "index_groups_on_rgt"
  add_index "groups", ["show_on_web"], :name => "index_groups_on_show_on_web"
  add_index "groups", ["small_group_leader_id"], :name => "index_groups_on_small_group_leader_id"
  add_index "groups", ["staff_person_responsible_id"], :name => "index_groups_on_staff_person_responsible_id"
  add_index "groups", ["tree_id"], :name => "index_groups_on_tree_id"

  create_table "groups_web_categories", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "web_category_id"
  end

  add_index "groups_web_categories", ["group_id"], :name => "group_id"
  add_index "groups_web_categories", ["web_category_id"], :name => "web_category_id"

  create_table "households", :force => true do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.integer  "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
    t.string   "attendance_status"
    t.string   "contribution_status"
    t.integer  "attend_count"
    t.datetime "deleted_at"
    t.string   "address"
    t.decimal  "lat",                 :precision => 15, :scale => 10
    t.decimal  "lng",                 :precision => 15, :scale => 10
  end

  add_index "households", ["address1"], :name => "index_households_on_address1"
  add_index "households", ["address2"], :name => "index_households_on_address2"
  add_index "households", ["deleted_at"], :name => "index_households_on_deleted_at"
  add_index "households", ["lat"], :name => "index_households_on_lat"
  add_index "households", ["lng"], :name => "index_households_on_lng"
  add_index "households", ["name"], :name => "index_households_on_name"
  add_index "households", ["zip"], :name => "index_households_on_zip"

  create_table "instance_types", :force => true do |t|
    t.string "name"
  end

  create_table "instances", :force => true do |t|
    t.integer  "instance_type_id"
    t.integer  "event_id"
    t.integer  "car_count"
    t.integer  "total_count"
    t.datetime "deleted_at"
  end

  add_index "instances", ["deleted_at"], :name => "index_instances_on_deleted_at"
  add_index "instances", ["event_id"], :name => "index_instances_on_event_id"
  add_index "instances", ["instance_type_id"], :name => "index_instances_on_instance_type_id"

  create_table "involvements", :force => true do |t|
    t.integer  "person_id"
    t.integer  "job_id"
    t.datetime "created_at", :default => '2007-12-05 22:14:28'
    t.datetime "updated_at", :default => '2007-12-05 22:14:28'
    t.datetime "deleted_at"
    t.date     "start_date"
    t.date     "end_date"
  end

  add_index "involvements", ["end_date"], :name => "index_involvements_on_end_date"
  add_index "involvements", ["job_id"], :name => "index_involvements_on_job_id"
  add_index "involvements", ["person_id"], :name => "index_involvements_on_person_id"
  add_index "involvements", ["start_date"], :name => "index_involvements_on_start_date"

  create_table "job_requirements", :force => true do |t|
    t.integer "job_id"
    t.integer "requirement_id"
  end

  create_table "jobs", :force => true do |t|
    t.string   "title"
    t.integer  "contact_person_id"
    t.text     "cadence"
    t.text     "description"
    t.text     "tasks"
    t.integer  "team_id"
    t.datetime "created_at",        :default => '2007-12-05 22:29:03'
    t.datetime "updated_at",        :default => '2007-12-05 22:29:03'
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "deleted_at"
  end

  add_index "jobs", ["deleted_at"], :name => "index_jobs_on_deleted_at"
  add_index "jobs", ["team_id"], :name => "index_jobs_on_team_id"
  add_index "jobs", ["title"], :name => "index_jobs_on_title"

  create_table "meetings", :force => true do |t|
    t.integer  "instance_id"
    t.integer  "group_id"
    t.integer  "room_id"
    t.datetime "real_date"
    t.text     "comments"
    t.integer  "leaders_count",      :default => 0
    t.integer  "participants_count", :default => 0
    t.integer  "total_count",        :default => 0
    t.datetime "deleted_at"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "num_marked"
  end

  add_index "meetings", ["deleted_at"], :name => "index_meetings_on_deleted_at"
  add_index "meetings", ["group_id"], :name => "index_meetings_on_group_id"
  add_index "meetings", ["instance_id"], :name => "index_meetings_on_instance_id"

  create_table "milestones", :force => true do |t|
    t.integer "person_id"
    t.integer "requirement_id"
    t.date    "start_date"
    t.date    "end_date"
    t.text    "comments"
    t.string  "created_by"
    t.string  "updated_by"
  end

  create_table "ministries", :force => true do |t|
    t.integer  "responsible_person_id"
    t.string   "responsible_person_title"
    t.text     "purpose"
    t.text     "win"
    t.string   "name"
    t.integer  "department_id"
    t.datetime "created_at",               :default => '2007-12-05 22:29:03'
    t.datetime "updated_at",               :default => '2007-12-05 22:29:03'
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "deleted_at"
  end

  add_index "ministries", ["deleted_at"], :name => "index_ministries_on_deleted_at"
  add_index "ministries", ["department_id"], :name => "index_ministries_on_department_id"
  add_index "ministries", ["responsible_person_id"], :name => "index_ministries_on_responsible_person_id"

  create_table "ministries_users", :id => false, :force => true do |t|
    t.integer "ministry_id"
    t.integer "user_id"
  end

  add_index "ministries_users", ["ministry_id"], :name => "index_ministries_users_on_ministry_id"
  add_index "ministries_users", ["user_id"], :name => "index_ministries_users_on_user_id"

  create_table "my_colors", :force => true do |t|
    t.string   "name"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "created_by"
    t.string   "updated_by"
  end

  create_table "note_types", :force => true do |t|
    t.string   "name"
    t.string   "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "updated_by"
  end

  create_table "notes", :force => true do |t|
    t.integer  "type_id"
    t.text     "text"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "updated_at"
    t.integer  "noteable_id"
    t.string   "noteable_type"
    t.datetime "created_at"
    t.boolean  "confidential"
  end

  add_index "notes", ["noteable_id"], :name => "index_notes_on_noteable_id"
  add_index "notes", ["noteable_type"], :name => "index_notes_on_noteable_type"
  add_index "notes", ["type_id"], :name => "index_notes_on_type_id"

  create_table "operators", :force => true do |t|
    t.integer "smart_group_property_id"
    t.string  "prose"
    t.string  "short"
  end

  add_index "operators", ["smart_group_property_id"], :name => "index_operators_on_smart_group_property_id"

  create_table "people", :force => true do |t|
    t.integer  "household_id"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "gender"
    t.date     "birthdate"
    t.string   "household_position"
    t.text     "allergies"
    t.integer  "default_group_id"
    t.string   "created_by"
    t.string   "updated_by"
    t.integer  "user_id"
    t.date     "max_date"
    t.string   "attendance_status"
    t.string   "contribution_status"
    t.integer  "attend_count"
    t.datetime "deleted_at"
    t.datetime "second_attend"
    t.integer  "worship_attends"
    t.date     "max_worship_date"
    t.date     "min_date"
    t.datetime "recent_contr"
    t.integer  "contr_count"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "people", ["attend_count"], :name => "index_people_on_attend_count"
  add_index "people", ["attendance_status"], :name => "index_people_on_attendance_status"
  add_index "people", ["birthdate"], :name => "index_people_on_birthdate"
  add_index "people", ["contr_count"], :name => "index_people_on_contr_count"
  add_index "people", ["default_group_id"], :name => "index_people_on_default_group_id"
  add_index "people", ["deleted_at"], :name => "index_people_on_deleted_at"
  add_index "people", ["first_name", "last_name"], :name => "full_name_index"
  add_index "people", ["first_name"], :name => "index_people_on_first_name"
  add_index "people", ["household_id"], :name => "index_people_on_household_id"
  add_index "people", ["household_position"], :name => "index_people_on_household_position"
  add_index "people", ["last_name"], :name => "index_people_on_last_name"
  add_index "people", ["max_worship_date"], :name => "index_people_on_max_worship_date"
  add_index "people", ["min_date"], :name => "index_people_on_min_date"
  add_index "people", ["recent_contr"], :name => "index_people_on_recent_contr"
  add_index "people", ["second_attend"], :name => "index_people_on_second_attend"
  add_index "people", ["worship_attends"], :name => "index_people_on_worship_attends"

  create_table "phones", :force => true do |t|
    t.integer  "household_id"
    t.integer  "person_id"
    t.string   "number"
    t.string   "comments"
    t.boolean  "primary"
    t.integer  "comm_type_id"
    t.integer  "phonable_id"
    t.string   "phonable_type"
    t.datetime "created_at",    :default => '2007-12-05 22:29:02'
    t.datetime "updated_at",    :default => '2007-12-05 22:29:02'
    t.integer  "sms_setup_id"
  end

  add_index "phones", ["number"], :name => "index_phones_on_number"
  add_index "phones", ["phonable_id", "phonable_type"], :name => "phonable_index"

  create_table "pictures", :force => true do |t|
    t.integer "person_id"
    t.integer "parent_id"
    t.integer "size"
    t.integer "width"
    t.integer "height"
    t.string  "content_type"
    t.string  "filename"
    t.string  "thumbnail"
  end

  add_index "pictures", ["parent_id"], :name => "index_pictures_on_parent_id"
  add_index "pictures", ["person_id"], :name => "index_pictures_on_person_id"

  create_table "plugin_schema_info", :id => false, :force => true do |t|
    t.string  "plugin_name"
    t.integer "version"
  end

  create_table "relationship_roles", :force => true do |t|
    t.string   "name"
    t.integer  "relationship_type_id"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationship_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.string   "created_by"
    t.datetime "updated_at"
    t.string   "updated_by"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "relationship_type_id"
    t.integer  "person_id"
    t.integer  "relates_to_id"
    t.integer  "person_role_id"
    t.integer  "relates_to_role_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "deactivated_on"
    t.boolean  "web_access"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comments"
  end

  add_index "relationships", ["deactivated_on"], :name => "index_relationships_on_deactivated_on"
  add_index "relationships", ["person_id"], :name => "index_relationships_on_person_id"
  add_index "relationships", ["relates_to_id"], :name => "index_relationships_on_relates_to_id"
  add_index "relationships", ["relationship_type_id"], :name => "index_relationships_on_relationship_type_id"

  create_table "requirements", :force => true do |t|
    t.string "name"
    t.text   "description"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
    t.string "alias"
    t.text   "description"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "rooms", :force => true do |t|
    t.string  "name"
    t.integer "number"
    t.integer "capacity"
  end

  create_table "rotations", :force => true do |t|
    t.string   "name"
    t.integer  "team_id"
    t.integer  "weeks_on"
    t.integer  "weeks_off"
    t.datetime "deleted_at"
  end

  add_index "rotations", ["team_id"], :name => "index_rotations_on_team_id"

  create_table "service_links", :force => true do |t|
    t.integer "group_id"
    t.integer "team_id"
  end

  add_index "service_links", ["group_id"], :name => "index_service_links_on_group_id"
  add_index "service_links", ["team_id"], :name => "index_service_links_on_team_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.integer  "current_instance"
    t.datetime "advance_decline_run_date"
  end

  create_table "smart_group_properties", :force => true do |t|
    t.string "prose"
    t.string "short"
    t.text   "instructions"
  end

  create_table "smart_group_rules", :force => true do |t|
    t.integer "smart_group_id"
    t.string  "content"
    t.integer "property_id"
    t.integer "operator_id"
  end

  add_index "smart_group_rules", ["smart_group_id"], :name => "index_smart_group_rules_on_smart_group_id"

  create_table "smart_groups", :force => true do |t|
    t.string   "name"
    t.text     "definition"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
  end

  create_table "sms_setups", :force => true do |t|
    t.string   "carrier_name"
    t.string   "config"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
  end

  create_table "tag_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :default => '2007-12-06 13:37:31'
    t.datetime "updated_at", :default => '2007-12-06 13:37:31'
    t.string   "created_by"
    t.string   "updated_by"
  end

  create_table "taggings", :force => true do |t|
    t.string   "comments"
    t.datetime "created_at", :default => '2007-12-06 13:37:31'
    t.datetime "updated_at", :default => '2007-12-06 13:37:31'
    t.string   "created_by"
    t.string   "updated_by"
    t.integer  "person_id"
    t.integer  "tag_id"
    t.date     "start_date"
    t.date     "end_date"
  end

  add_index "taggings", ["person_id"], :name => "index_taggings_on_person_id"
  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",   :default => '2007-12-06 13:37:30'
    t.datetime "updated_at",   :default => '2007-12-06 13:37:30'
    t.string   "created_by"
    t.string   "updated_by"
    t.integer  "tag_group_id"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"
  add_index "tags", ["tag_group_id"], :name => "index_tags_on_tag_group_id"

  create_table "teams", :force => true do |t|
    t.integer  "responsible_person_id"
    t.string   "responsible_person_title"
    t.text     "purpose"
    t.text     "win"
    t.string   "name"
    t.integer  "ministry_id"
    t.datetime "created_at",               :default => '2007-12-05 22:29:02'
    t.datetime "updated_at",               :default => '2007-12-05 22:29:02'
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "deleted_at"
  end

  add_index "teams", ["deleted_at"], :name => "deleted_at"
  add_index "teams", ["ministry_id"], :name => "ministry_id"
  add_index "teams", ["responsible_person_id"], :name => "index_teams_on_responsible_person_id"

  create_table "tools", :force => true do |t|
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password_reset_code",       :limit => 40
    t.string   "group_scope"
    t.boolean  "is_staff"
  end

  create_table "web_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
  end

end
