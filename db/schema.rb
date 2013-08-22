# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130822180956) do

  create_table "adjectives", force: true do |t|
    t.string   "name"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "created_by"
    t.string   "updated_by"
  end

  create_table "animals", force: true do |t|
    t.string   "name"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "created_by"
    t.string   "updated_by"
  end

  create_table "assignments", force: true do |t|
    t.integer "involvement_id"
    t.integer "meeting_id"
  end

  add_index "assignments", ["involvement_id"], name: "index_assignments_on_involvement_id", using: :btree
  add_index "assignments", ["meeting_id"], name: "index_assignments_on_meeting_id", using: :btree

  create_table "associates", force: true do |t|
    t.integer  "organization_id"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "comments"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "associates", ["id"], name: "index_associates_on_id", using: :btree
  add_index "associates", ["organization_id"], name: "index_associates_on_organization_id", using: :btree

  create_table "attendance_trackers", force: true do |t|
    t.integer  "person_id"
    t.integer  "group_id"
    t.datetime "most_recent_attend"
    t.datetime "first_attend"
    t.integer  "count"
  end

  add_index "attendance_trackers", ["count"], name: "index_attendance_trackers_on_count", using: :btree
  add_index "attendance_trackers", ["first_attend"], name: "index_attendance_trackers_on_first_attend", using: :btree
  add_index "attendance_trackers", ["group_id"], name: "index_attendance_trackers_on_group_id", using: :btree
  add_index "attendance_trackers", ["most_recent_attend"], name: "index_attendance_trackers_on_most_recent_attend", using: :btree
  add_index "attendance_trackers", ["person_id"], name: "index_attendance_trackers_on_person_id", using: :btree

  create_table "attendances", force: true do |t|
    t.integer  "person_id"
    t.integer  "meeting_id"
    t.datetime "checkin_time"
    t.datetime "checkout_time"
    t.integer  "checkin_type_id"
    t.string   "security_code"
    t.string   "call_number"
  end

  add_index "attendances", ["checkin_type_id"], name: "index_attendances_on_checkin_type_id", using: :btree
  add_index "attendances", ["meeting_id"], name: "index_attendances_on_meeting_id", using: :btree
  add_index "attendances", ["person_id"], name: "index_attendances_on_person_id", using: :btree

  create_table "audits", force: true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "changes"
    t.integer  "version",        default: 0
    t.datetime "created_at"
  end

  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "auto_groups", force: true do |t|
    t.integer "instance_type_id"
    t.integer "group_id"
  end

  add_index "auto_groups", ["group_id"], name: "index_auto_groups_on_group_id", using: :btree
  add_index "auto_groups", ["instance_type_id"], name: "index_auto_groups_on_instance_type_id", using: :btree

  create_table "auto_instance_types", force: true do |t|
    t.integer "event_type_id"
    t.integer "instance_type_id"
  end

  add_index "auto_instance_types", ["event_type_id"], name: "index_auto_instance_types_on_event_type_id", using: :btree
  add_index "auto_instance_types", ["instance_type_id"], name: "index_auto_instance_types_on_instance_type_id", using: :btree

  create_table "batches", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
    t.text     "comments"
    t.datetime "date_collected"
    t.decimal  "count_total",       precision: 9, scale: 2
    t.integer  "contributions_num"
    t.boolean  "locked",                                    default: false
    t.datetime "deleted_at"
    t.decimal  "loose_cash",        precision: 9, scale: 2
  end

  add_index "batches", ["created_at"], name: "index_batches_on_created_at", using: :btree
  add_index "batches", ["date_collected"], name: "index_batches_on_date_collected", using: :btree
  add_index "batches", ["deleted_at"], name: "index_batches_on_deleted_at", using: :btree

  create_table "cadences", force: true do |t|
    t.string   "name"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cadences", ["name"], name: "index_cadences_on_name", using: :btree

  create_table "calls", force: true do |t|
    t.string   "from"
    t.string   "to"
    t.string   "sid"
    t.string   "rec_sid"
    t.string   "rec_url"
    t.string   "rec_duration"
    t.integer  "for_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "audio"
  end

  add_index "calls", ["for_user_id"], name: "index_calls_on_for_user_id", using: :btree
  add_index "calls", ["from"], name: "index_calls_on_from", using: :btree
  add_index "calls", ["rec_sid"], name: "index_calls_on_rec_sid", using: :btree
  add_index "calls", ["sid"], name: "index_calls_on_sid", using: :btree

  create_table "ccolors", force: true do |t|
    t.string   "name"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "created_by"
    t.string   "updated_by"
  end

  create_table "checkin_backgrounds", force: true do |t|
    t.string   "name"
    t.string   "graphic"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "checkin_types", force: true do |t|
    t.string "name"
  end

  create_table "comm_types", force: true do |t|
    t.string "name"
  end

  create_table "contact_forms", force: true do |t|
    t.string   "name"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_forms_contact_types", id: false, force: true do |t|
    t.integer "contact_form_id"
    t.integer "contact_type_id"
  end

  add_index "contact_forms_contact_types", ["contact_form_id"], name: "index_contact_forms_contact_types_on_contact_form_id", using: :btree
  add_index "contact_forms_contact_types", ["contact_type_id"], name: "index_contact_forms_contact_types_on_contact_type_id", using: :btree

  create_table "contact_types", force: true do |t|
    t.string   "name"
    t.integer  "default_responsible_user_id"
    t.integer  "default_responsible_ministry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
    t.boolean  "multiple_close",                  default: false
    t.boolean  "notiphy"
    t.boolean  "quick_contact"
    t.integer  "default_follow_up_type_id"
    t.boolean  "confidential"
    t.datetime "deactivated_at"
  end

  add_index "contact_types", ["deactivated_at"], name: "index_contact_types_on_deactivated_at", using: :btree
  add_index "contact_types", ["default_follow_up_type_id"], name: "index_contact_types_on_default_follow_up_type_id", using: :btree
  add_index "contact_types", ["default_responsible_ministry_id"], name: "index_contact_types_on_default_responsible_ministry_id", using: :btree
  add_index "contact_types", ["default_responsible_user_id"], name: "index_contact_types_on_default_responsible_user_id", using: :btree
  add_index "contact_types", ["quick_contact"], name: "index_contact_types_on_quick_contact", using: :btree

  create_table "contacts", force: true do |t|
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
    t.boolean  "openn",                   default: true
    t.datetime "closed_at"
    t.datetime "deleted_at"
    t.string   "stamp"
    t.datetime "reopen_at"
    t.string   "status"
    t.integer  "contactable_id"
    t.string   "contactable_type"
  end

  add_index "contacts", ["closed_at"], name: "index_contacts_on_closed_at", using: :btree
  add_index "contacts", ["contact_type_id"], name: "index_contacts_on_contact_type_id", using: :btree
  add_index "contacts", ["contactable_id"], name: "index_contacts_on_contactable_id", using: :btree
  add_index "contacts", ["contactable_type"], name: "index_contacts_on_contactable_type", using: :btree
  add_index "contacts", ["created_at"], name: "index_contacts_on_created_at", using: :btree
  add_index "contacts", ["created_by"], name: "index_contacts_on_created_by", using: :btree
  add_index "contacts", ["deleted_at"], name: "index_contacts_on_deleted_at", using: :btree
  add_index "contacts", ["household_id"], name: "index_contacts_on_household_id", using: :btree
  add_index "contacts", ["person_id"], name: "index_contacts_on_person_id", using: :btree
  add_index "contacts", ["reopen_at"], name: "index_contacts_on_reopen_at", using: :btree
  add_index "contacts", ["responsible_ministry_id"], name: "index_contacts_on_responsible_ministry_id", using: :btree
  add_index "contacts", ["responsible_user_id"], name: "index_contacts_on_responsible_user_id", using: :btree
  add_index "contacts", ["stamp"], name: "index_contacts_on_stamp", using: :btree
  add_index "contacts", ["status"], name: "index_contacts_on_status", using: :btree

  create_table "contributions", force: true do |t|
    t.decimal  "total",              precision: 9, scale: 2
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
    t.integer  "contributable_id"
    t.string   "contributable_type"
  end

  add_index "contributions", ["batch_id"], name: "index_contributions_on_batch_id", using: :btree
  add_index "contributions", ["contributable_id"], name: "index_contributions_on_contributable_id", using: :btree
  add_index "contributions", ["created_at"], name: "index_contributions_on_created_at", using: :btree
  add_index "contributions", ["deleted_at"], name: "index_contributions_on_deleted_at", using: :btree
  add_index "contributions", ["person_id"], name: "index_contributions_on_person_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "departments", force: true do |t|
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

  add_index "departments", ["responsible_person_id"], name: "index_departments_on_responsible_person_id", using: :btree

  create_table "deployments", force: true do |t|
    t.integer "rotation_id"
    t.integer "involvement_id"
  end

  add_index "deployments", ["involvement_id"], name: "index_deployments_on_involvement_id", using: :btree
  add_index "deployments", ["rotation_id"], name: "index_deployments_on_rotation_id", using: :btree

  create_table "donations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
    t.text     "comments"
    t.integer  "contribution_id"
    t.decimal  "amount",          precision: 9, scale: 2
    t.integer  "fund_id"
  end

  add_index "donations", ["contribution_id"], name: "index_donations_on_contribution_id", using: :btree
  add_index "donations", ["created_at"], name: "index_donations_on_created_at", using: :btree
  add_index "donations", ["fund_id"], name: "index_donations_on_fund_id", using: :btree

  create_table "emails", force: true do |t|
    t.integer  "person_id"
    t.integer  "household_id"
    t.string   "email"
    t.integer  "emailable_id"
    t.string   "emailable_type"
    t.string   "comments"
    t.boolean  "primary"
    t.integer  "comm_type_id"
    t.datetime "updated_at"
  end

  add_index "emails", ["comm_type_id"], name: "index_emails_on_comm_type_id", using: :btree
  add_index "emails", ["email"], name: "index_emails_on_email", using: :btree
  add_index "emails", ["emailable_id", "emailable_type"], name: "emailable_index", using: :btree
  add_index "emails", ["household_id"], name: "index_emails_on_household_id", using: :btree
  add_index "emails", ["person_id"], name: "index_emails_on_person_id", using: :btree

  create_table "enrollments", force: true do |t|
    t.integer  "person_id"
    t.integer  "group_id"
    t.integer  "enrolled_as_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  add_index "enrollments", ["end_time"], name: "index_enrollments_on_end_time", using: :btree
  add_index "enrollments", ["enrolled_as_id"], name: "index_enrollments_on_enrolled_as_id", using: :btree
  add_index "enrollments", ["group_id"], name: "index_enrollments_on_group_id", using: :btree
  add_index "enrollments", ["person_id"], name: "index_enrollments_on_person_id", using: :btree
  add_index "enrollments", ["start_time"], name: "index_enrollments_on_start_time", using: :btree

  create_table "event_types", force: true do |t|
    t.string "name"
  end

  create_table "events", force: true do |t|
    t.integer  "event_type_id"
    t.date     "date"
    t.string   "name"
    t.integer  "total_count",   default: 0
    t.datetime "deleted_at"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["date"], name: "index_events_on_date", using: :btree
  add_index "events", ["deleted_at"], name: "index_events_on_deleted_at", using: :btree
  add_index "events", ["event_type_id"], name: "index_events_on_event_type_id", using: :btree

  create_table "favorites", force: true do |t|
    t.integer  "favoritable_id"
    t.string   "favoritable_type"
    t.integer  "user_id"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["favoritable_id"], name: "index_favorites_on_favoritable_id", using: :btree
  add_index "favorites", ["favoritable_type"], name: "index_favorites_on_favoritable_type", using: :btree
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "follow_up_types", force: true do |t|
    t.string "name"
  end

  create_table "follow_ups", force: true do |t|
    t.text     "notes"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "follow_up_type_id"
    t.integer  "contact_id"
  end

  add_index "follow_ups", ["contact_id"], name: "index_follow_ups_on_contact_id", using: :btree
  add_index "follow_ups", ["created_at"], name: "index_follow_ups_on_created_at", using: :btree
  add_index "follow_ups", ["created_by"], name: "index_follow_ups_on_created_by", using: :btree
  add_index "follow_ups", ["follow_up_type_id"], name: "index_follow_ups_on_follow_up_type_id", using: :btree

  create_table "frequencies", force: true do |t|
    t.integer  "group_id"
    t.integer  "cadence_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "frequencies", ["cadence_id"], name: "index_frequencies_on_cadence_id", using: :btree
  add_index "frequencies", ["group_id"], name: "index_frequencies_on_group_id", using: :btree

  create_table "funds", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
    t.text     "comments"
    t.string   "name"
  end

  create_table "group_bys", force: true do |t|
    t.integer  "record_type_id"
    t.string   "column_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_bys", ["record_type_id"], name: "index_group_bys_on_record_type_id", using: :btree

  create_table "group_choices", force: true do |t|
    t.string "type"
    t.string "name"
  end

  add_index "group_choices", ["type"], name: "index_group_choices_on_type", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.integer  "default_room_id"
    t.boolean  "auto_create"
    t.integer  "staff_ratio"
    t.string   "meeting_is_called"
    t.boolean  "checkin_group",               default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "parent_id"
    t.integer  "lft",                                         null: false
    t.integer  "rgt",                                         null: false
    t.string   "created_by"
    t.string   "updated_by"
    t.integer  "curriculum_choice_id"
    t.integer  "curriculum_cost_id"
    t.integer  "special_requirement_id"
    t.integer  "meeting_cadence_id"
    t.integer  "meeting_place_id"
    t.integer  "attendance_requirement_id"
    t.integer  "is_childcare_provided_id"
    t.boolean  "closed",                      default: false
    t.integer  "small_group_leader_id"
    t.integer  "staff_person_responsible_id"
    t.integer  "responsible_person_id"
    t.boolean  "active",                      default: true
    t.integer  "meets_at_household_id"
    t.integer  "leader_name_for_printing_id"
    t.text     "blurb"
    t.string   "meets_on"
    t.time     "time_from"
    t.time     "time_until"
    t.boolean  "show_on_web",                 default: false
    t.datetime "deleted_at"
    t.datetime "archived_at"
    t.integer  "tree_id"
    t.string   "type"
    t.integer  "cadence_id"
    t.text     "description"
    t.boolean  "suppress_stickers",           default: false
    t.integer  "inquiry_number"
  end

  add_index "groups", ["active"], name: "index_groups_on_active", using: :btree
  add_index "groups", ["archived_at"], name: "index_groups_on_archived_at", using: :btree
  add_index "groups", ["attendance_requirement_id"], name: "index_groups_on_attendance_requirement_id", using: :btree
  add_index "groups", ["cadence_id"], name: "index_groups_on_cadence_id", using: :btree
  add_index "groups", ["curriculum_choice_id"], name: "index_groups_on_curriculum_choice_id", using: :btree
  add_index "groups", ["curriculum_cost_id"], name: "index_groups_on_curriculum_cost_id", using: :btree
  add_index "groups", ["default_room_id"], name: "index_groups_on_default_room_id", using: :btree
  add_index "groups", ["deleted_at"], name: "index_groups_on_deleted_at", using: :btree
  add_index "groups", ["is_childcare_provided_id"], name: "index_groups_on_is_childcare_provided_id", using: :btree
  add_index "groups", ["leader_name_for_printing_id"], name: "index_groups_on_leader_name_for_printing_id", using: :btree
  add_index "groups", ["lft"], name: "index_groups_on_lft", using: :btree
  add_index "groups", ["meeting_cadence_id"], name: "index_groups_on_meeting_cadence_id", using: :btree
  add_index "groups", ["meeting_place_id"], name: "index_groups_on_meeting_place_id", using: :btree
  add_index "groups", ["meets_at_household_id"], name: "index_groups_on_meets_at_household_id", using: :btree
  add_index "groups", ["name"], name: "index_groups_on_name", using: :btree
  add_index "groups", ["parent_id"], name: "index_groups_on_parent_id", using: :btree
  add_index "groups", ["responsible_person_id"], name: "index_groups_on_responsible_person_id", using: :btree
  add_index "groups", ["rgt"], name: "index_groups_on_rgt", using: :btree
  add_index "groups", ["show_on_web"], name: "index_groups_on_show_on_web", using: :btree
  add_index "groups", ["small_group_leader_id"], name: "index_groups_on_small_group_leader_id", using: :btree
  add_index "groups", ["special_requirement_id"], name: "index_groups_on_special_requirement_id", using: :btree
  add_index "groups", ["staff_person_responsible_id"], name: "index_groups_on_staff_person_responsible_id", using: :btree
  add_index "groups", ["tree_id"], name: "index_groups_on_tree_id", using: :btree
  add_index "groups", ["type"], name: "index_groups_on_type", using: :btree

  create_table "groups_web_categories", id: false, force: true do |t|
    t.integer "group_id"
    t.integer "web_category_id"
  end

  add_index "groups_web_categories", ["group_id"], name: "index_groups_web_categories_on_group_id", using: :btree
  add_index "groups_web_categories", ["web_category_id"], name: "index_groups_web_categories_on_web_category_id", using: :btree

  create_table "households", force: true do |t|
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
    t.decimal  "latitude",            precision: 15, scale: 10
    t.decimal  "longitude",           precision: 15, scale: 10
    t.integer  "email_counter"
  end

  add_index "households", ["address1"], name: "index_households_on_address1", using: :btree
  add_index "households", ["address2"], name: "index_households_on_address2", using: :btree
  add_index "households", ["deleted_at"], name: "index_households_on_deleted_at", using: :btree
  add_index "households", ["email_counter"], name: "index_households_on_email_counter", using: :btree
  add_index "households", ["latitude"], name: "index_households_on_latitude", using: :btree
  add_index "households", ["longitude"], name: "index_households_on_longitude", using: :btree
  add_index "households", ["name"], name: "index_households_on_name", using: :btree
  add_index "households", ["zip"], name: "index_households_on_zip", using: :btree

  create_table "inquiries", force: true do |t|
    t.integer  "person_id"
    t.integer  "group_id"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "inquiries", ["group_id"], name: "index_inquiries_on_group_id", using: :btree
  add_index "inquiries", ["person_id"], name: "index_inquiries_on_person_id", using: :btree

  create_table "instance_types", force: true do |t|
    t.string   "name"
    t.datetime "start_time"
  end

  add_index "instance_types", ["start_time"], name: "index_instance_types_on_start_time", using: :btree

  create_table "instances", force: true do |t|
    t.integer  "instance_type_id"
    t.integer  "event_id"
    t.boolean  "auto_create"
    t.integer  "car_count",        default: 0
    t.integer  "total_count",      default: 0
    t.datetime "deleted_at"
  end

  add_index "instances", ["deleted_at"], name: "index_instances_on_deleted_at", using: :btree
  add_index "instances", ["event_id"], name: "index_instances_on_event_id", using: :btree
  add_index "instances", ["instance_type_id"], name: "index_instances_on_instance_type_id", using: :btree

  create_table "interjections", force: true do |t|
    t.string   "name"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "involvements", force: true do |t|
    t.integer  "person_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.date     "start_date"
    t.date     "end_date"
  end

  add_index "involvements", ["end_date"], name: "index_involvements_on_end_date", using: :btree
  add_index "involvements", ["job_id"], name: "index_involvements_on_job_id", using: :btree
  add_index "involvements", ["person_id"], name: "index_involvements_on_person_id", using: :btree
  add_index "involvements", ["start_date"], name: "index_involvements_on_start_date", using: :btree

  create_table "job_requirements", force: true do |t|
    t.integer "job_id"
    t.integer "requirement_id"
  end

  add_index "job_requirements", ["job_id"], name: "index_job_requirements_on_job_id", using: :btree
  add_index "job_requirements", ["requirement_id"], name: "index_job_requirements_on_requirement_id", using: :btree

  create_table "jobs", force: true do |t|
    t.string   "title"
    t.integer  "contact_person_id"
    t.text     "cadence"
    t.text     "description"
    t.text     "tasks"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "deleted_at"
  end

  add_index "jobs", ["contact_person_id"], name: "index_jobs_on_contact_person_id", using: :btree
  add_index "jobs", ["deleted_at"], name: "index_jobs_on_deleted_at", using: :btree
  add_index "jobs", ["team_id"], name: "index_jobs_on_team_id", using: :btree
  add_index "jobs", ["title"], name: "index_jobs_on_title", using: :btree

  create_table "layouts", force: true do |t|
    t.integer  "record_type_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "layouts", ["record_type_id"], name: "index_layouts_on_record_type_id", using: :btree

  create_table "leaderships", force: true do |t|
    t.integer  "leadable_id"
    t.string   "leadable_type"
    t.string   "type"
    t.integer  "person_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "leaderships", ["leadable_id"], name: "index_leaderships_on_leadable_id", using: :btree
  add_index "leaderships", ["leadable_type"], name: "index_leaderships_on_leadable_type", using: :btree
  add_index "leaderships", ["person_id"], name: "index_leaderships_on_person_id", using: :btree
  add_index "leaderships", ["type"], name: "index_leaderships_on_type", using: :btree

  create_table "meeting_times", force: true do |t|
    t.datetime "time"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meetings", force: true do |t|
    t.integer  "instance_id"
    t.integer  "group_id"
    t.integer  "room_id"
    t.datetime "real_date"
    t.text     "comments"
    t.integer  "leaders_count",      default: 0
    t.integer  "participants_count", default: 0
    t.integer  "total_count",        default: 0
    t.datetime "deleted_at"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "num_marked"
    t.string   "checkin_code"
  end

  add_index "meetings", ["checkin_code"], name: "index_meetings_on_checkin_code", using: :btree
  add_index "meetings", ["deleted_at"], name: "index_meetings_on_deleted_at", using: :btree
  add_index "meetings", ["group_id"], name: "index_meetings_on_group_id", using: :btree
  add_index "meetings", ["instance_id"], name: "index_meetings_on_instance_id", using: :btree
  add_index "meetings", ["room_id"], name: "index_meetings_on_room_id", using: :btree

  create_table "meets_ats", force: true do |t|
    t.integer  "group_id"
    t.integer  "meeting_time_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meets_ats", ["group_id"], name: "index_meets_ats_on_group_id", using: :btree
  add_index "meets_ats", ["meeting_time_id"], name: "index_meets_ats_on_meeting_time_id", using: :btree

  create_table "meets_ons", force: true do |t|
    t.integer  "group_id"
    t.integer  "weekday_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meets_ons", ["group_id"], name: "index_meets_ons_on_group_id", using: :btree
  add_index "meets_ons", ["weekday_id"], name: "index_meets_ons_on_weekday_id", using: :btree

  create_table "messages", force: true do |t|
    t.string   "from"
    t.text     "body"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.integer  "user_id"
    t.integer  "ancestry_depth", default: 0
  end

  add_index "messages", ["ancestry"], name: "index_messages_on_ancestry", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "milestones", force: true do |t|
    t.integer "person_id"
    t.integer "requirement_id"
    t.date    "start_date"
    t.date    "end_date"
    t.text    "comments"
    t.string  "created_by"
    t.string  "updated_by"
  end

  add_index "milestones", ["person_id"], name: "index_milestones_on_person_id", using: :btree
  add_index "milestones", ["requirement_id"], name: "index_milestones_on_requirement_id", using: :btree

  create_table "ministries", force: true do |t|
    t.integer  "responsible_person_id"
    t.string   "responsible_person_title"
    t.text     "purpose"
    t.text     "win"
    t.string   "name"
    t.integer  "department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "deleted_at"
  end

  add_index "ministries", ["deleted_at"], name: "index_ministries_on_deleted_at", using: :btree
  add_index "ministries", ["department_id"], name: "index_ministries_on_department_id", using: :btree
  add_index "ministries", ["responsible_person_id"], name: "index_ministries_on_responsible_person_id", using: :btree

  create_table "ministries_users", id: false, force: true do |t|
    t.integer "ministry_id"
    t.integer "user_id"
  end

  add_index "ministries_users", ["ministry_id"], name: "index_ministries_users_on_ministry_id", using: :btree
  add_index "ministries_users", ["user_id"], name: "index_ministries_users_on_user_id", using: :btree

  create_table "my_colors", force: true do |t|
    t.string   "name"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "created_by"
    t.string   "updated_by"
  end

  create_table "note_types", force: true do |t|
    t.string   "name"
    t.string   "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "updated_by"
  end

  create_table "notes", force: true do |t|
    t.integer  "type_id"
    t.text     "text"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "updated_at"
    t.integer  "noteable_id"
    t.string   "noteable_type"
    t.boolean  "confidential"
    t.datetime "created_at"
  end

  add_index "notes", ["noteable_id"], name: "index_notes_on_noteable_id", using: :btree
  add_index "notes", ["noteable_type"], name: "index_notes_on_noteable_type", using: :btree
  add_index "notes", ["type_id"], name: "index_notes_on_type_id", using: :btree

  create_table "operators", force: true do |t|
    t.integer "smart_group_property_id"
    t.string  "prose"
    t.string  "short"
  end

  add_index "operators", ["smart_group_property_id"], name: "index_operators_on_smart_group_property_id", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.integer  "zip"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "recent_contr"
    t.integer  "contr_count",                            default: 0
    t.string   "address"
    t.decimal  "lat",          precision: 15, scale: 10
    t.decimal  "lng",          precision: 15, scale: 10
  end

  add_index "organizations", ["contr_count"], name: "index_organizations_on_contr_count", using: :btree
  add_index "organizations", ["id"], name: "index_organizations_on_id", using: :btree
  add_index "organizations", ["recent_contr"], name: "index_organizations_on_recent_contr", using: :btree

  create_table "people", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "worship_attends"
    t.date     "max_worship_date"
    t.date     "min_date"
    t.datetime "recent_contr"
    t.integer  "contr_count",         default: 0
    t.boolean  "has_a_picture",       default: false
    t.boolean  "enrolled",            default: false
    t.boolean  "involved",            default: false
    t.boolean  "connected",           default: false
    t.integer  "birth_day"
    t.integer  "birth_month"
    t.integer  "email_counter"
    t.string   "image"
    t.string   "facebook_uid"
    t.string   "facebook_url"
  end

  add_index "people", ["attend_count"], name: "index_people_on_attend_count", using: :btree
  add_index "people", ["attendance_status"], name: "index_people_on_attendance_status", using: :btree
  add_index "people", ["birth_day"], name: "index_people_on_birth_day", using: :btree
  add_index "people", ["birth_month"], name: "index_people_on_birth_month", using: :btree
  add_index "people", ["birthdate"], name: "index_people_on_birthdate", using: :btree
  add_index "people", ["connected"], name: "index_people_on_connected", using: :btree
  add_index "people", ["contr_count"], name: "index_people_on_contr_count", using: :btree
  add_index "people", ["default_group_id"], name: "index_people_on_default_group_id", using: :btree
  add_index "people", ["deleted_at"], name: "index_people_on_deleted_at", using: :btree
  add_index "people", ["email_counter"], name: "index_people_on_email_counter", using: :btree
  add_index "people", ["enrolled"], name: "index_people_on_enrolled", using: :btree
  add_index "people", ["first_name", "last_name"], name: "full_name_index", using: :btree
  add_index "people", ["first_name"], name: "index_people_on_first_name", using: :btree
  add_index "people", ["has_a_picture"], name: "index_people_on_has_a_picture", using: :btree
  add_index "people", ["household_id"], name: "index_people_on_household_id", using: :btree
  add_index "people", ["household_position"], name: "index_people_on_household_position", using: :btree
  add_index "people", ["involved"], name: "index_people_on_involved", using: :btree
  add_index "people", ["last_name"], name: "index_people_on_last_name", using: :btree
  add_index "people", ["max_date"], name: "index_people_on_max_date", using: :btree
  add_index "people", ["max_worship_date"], name: "index_people_on_max_worship_date", using: :btree
  add_index "people", ["min_date"], name: "index_people_on_min_date", using: :btree
  add_index "people", ["recent_contr"], name: "index_people_on_recent_contr", using: :btree
  add_index "people", ["second_attend"], name: "index_people_on_second_attend", using: :btree
  add_index "people", ["user_id"], name: "index_people_on_user_id", using: :btree
  add_index "people", ["worship_attends"], name: "index_people_on_worship_attends", using: :btree

  create_table "permissions", force: true do |t|
    t.string   "resource_name"
    t.string   "ability_name"
    t.string   "description"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phones", force: true do |t|
    t.integer  "household_id"
    t.integer  "person_id"
    t.string   "number"
    t.string   "comments"
    t.boolean  "primary"
    t.integer  "comm_type_id"
    t.integer  "phonable_id"
    t.string   "phonable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sms_setup_id"
  end

  add_index "phones", ["comm_type_id"], name: "index_phones_on_comm_type_id", using: :btree
  add_index "phones", ["household_id"], name: "index_phones_on_household_id", using: :btree
  add_index "phones", ["number"], name: "index_phones_on_number", using: :btree
  add_index "phones", ["person_id"], name: "index_phones_on_person_id", using: :btree
  add_index "phones", ["phonable_id", "phonable_type"], name: "phonable_index", using: :btree
  add_index "phones", ["sms_setup_id"], name: "index_phones_on_sms_setup_id", using: :btree

  create_table "pictures", force: true do |t|
    t.integer "person_id"
    t.integer "parent_id"
    t.integer "size"
    t.integer "width"
    t.integer "height"
    t.string  "content_type"
    t.string  "filename"
    t.string  "thumbnail"
  end

  add_index "pictures", ["parent_id"], name: "index_pictures_on_parent_id", using: :btree
  add_index "pictures", ["person_id"], name: "index_pictures_on_person_id", using: :btree

  create_table "plugin_schema_info", id: false, force: true do |t|
    t.string  "plugin_name"
    t.integer "version",     null: false
  end

  create_table "property_operators", force: true do |t|
    t.integer  "smart_group_property_id"
    t.integer  "operator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "property_operators", ["operator_id"], name: "index_property_operators_on_operator_id", using: :btree
  add_index "property_operators", ["smart_group_property_id"], name: "index_property_operators_on_smart_group_property_id", using: :btree

  create_table "recipients", force: true do |t|
    t.string   "number"
    t.integer  "person_id"
    t.integer  "message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recipients", ["message_id"], name: "index_recipients_on_message_id", using: :btree
  add_index "recipients", ["number"], name: "index_recipients_on_number", using: :btree
  add_index "recipients", ["person_id"], name: "index_recipients_on_person_id", using: :btree

  create_table "record_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationship_roles", force: true do |t|
    t.string   "name"
    t.integer  "relationship_type_id"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationship_roles", ["relationship_type_id"], name: "index_relationship_roles_on_relationship_type_id", using: :btree

  create_table "relationship_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.string   "created_by"
    t.datetime "updated_at"
    t.string   "updated_by"
    t.boolean  "auto_notify"
    t.string   "recipients"
  end

  create_table "relationships", force: true do |t|
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

  add_index "relationships", ["deactivated_on"], name: "index_relationships_on_deactivated_on", using: :btree
  add_index "relationships", ["person_id"], name: "index_relationships_on_person_id", using: :btree
  add_index "relationships", ["person_role_id"], name: "index_relationships_on_person_role_id", using: :btree
  add_index "relationships", ["relates_to_id"], name: "index_relationships_on_relates_to_id", using: :btree
  add_index "relationships", ["relates_to_role_id"], name: "index_relationships_on_relates_to_role_id", using: :btree
  add_index "relationships", ["relationship_type_id"], name: "index_relationships_on_relationship_type_id", using: :btree

  create_table "reports", force: true do |t|
    t.string   "name"
    t.integer  "record_type_id"
    t.text     "parameters"
    t.string   "layout"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_by_id"
    t.integer  "layout_id"
    t.string   "range"
  end

  add_index "reports", ["group_by_id"], name: "index_reports_on_group_by_id", using: :btree
  add_index "reports", ["layout_id"], name: "index_reports_on_layout_id", using: :btree
  add_index "reports", ["record_type_id"], name: "index_reports_on_record_type_id", using: :btree

  create_table "requirements", force: true do |t|
    t.string "name"
    t.text   "description"
  end

  create_table "rev_clean_install", force: true do |t|
  end

  create_table "role_permissions", force: true do |t|
    t.integer  "role_id"
    t.integer  "permission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "role_permissions", ["permission_id"], name: "index_role_permissions_on_permission_id", using: :btree
  add_index "role_permissions", ["role_id"], name: "index_role_permissions_on_role_id", using: :btree

  create_table "roles", force: true do |t|
    t.string "name"
    t.string "alias"
    t.text   "description"
  end

  create_table "roles_users", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], name: "index_roles_users_on_role_id", using: :btree
  add_index "roles_users", ["user_id"], name: "index_roles_users_on_user_id", using: :btree

  create_table "rooms", force: true do |t|
    t.string  "name"
    t.integer "number"
    t.integer "capacity"
  end

  create_table "rotations", force: true do |t|
    t.string   "name"
    t.integer  "team_id"
    t.integer  "weeks_on"
    t.integer  "weeks_off"
    t.datetime "deleted_at"
  end

  add_index "rotations", ["team_id"], name: "index_rotations_on_team_id", using: :btree

  create_table "rude_queues", force: true do |t|
    t.string   "queue_name"
    t.text     "data"
    t.boolean  "processed",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rude_queues", ["processed"], name: "index_rude_queues_on_processed", using: :btree
  add_index "rude_queues", ["queue_name", "processed"], name: "index_rude_queues_on_queue_name_and_processed", using: :btree

  create_table "searches", force: true do |t|
    t.string   "klass"
    t.text     "parameters"
    t.text     "created_by"
    t.text     "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "searches", ["klass"], name: "index_searches_on_klass", using: :btree

  create_table "service_links", force: true do |t|
    t.integer "group_id"
    t.integer "team_id"
  end

  add_index "service_links", ["group_id"], name: "index_service_links_on_group_id", using: :btree
  add_index "service_links", ["team_id"], name: "index_service_links_on_team_id", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "settings", force: true do |t|
    t.string   "key"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["key"], name: "key_udx", unique: true, using: :btree

  create_table "sign_ups", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "phone"
    t.string   "step"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "meeting_id"
  end

  add_index "sign_ups", ["meeting_id"], name: "index_sign_ups_on_meeting_id", using: :btree

  create_table "smart_group_properties", force: true do |t|
    t.string "prose"
    t.string "short"
    t.text   "instructions"
  end

  create_table "smart_group_rules", force: true do |t|
    t.integer "smart_group_id"
    t.string  "property"
    t.string  "operator"
    t.string  "content"
    t.integer "property_id"
    t.integer "operator_id"
  end

  add_index "smart_group_rules", ["operator_id"], name: "index_smart_group_rules_on_operator_id", using: :btree
  add_index "smart_group_rules", ["property_id"], name: "index_smart_group_rules_on_property_id", using: :btree
  add_index "smart_group_rules", ["smart_group_id"], name: "index_smart_group_rules_on_smart_group_id", using: :btree

  create_table "smart_groups", force: true do |t|
    t.string   "name"
    t.text     "definition"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
  end

  create_table "sms_setups", force: true do |t|
    t.string   "carrier_name"
    t.string   "config"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
  end

  create_table "tag_groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
  end

  create_table "taggings", force: true do |t|
    t.string   "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
    t.integer  "person_id"
    t.integer  "tag_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "tag_group_id"
  end

  add_index "taggings", ["person_id"], name: "index_taggings_on_person_id", using: :btree
  add_index "taggings", ["tag_group_id"], name: "index_taggings_on_tag_group_id", using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
    t.integer  "tag_group_id"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree
  add_index "tags", ["tag_group_id"], name: "index_tags_on_tag_group_id", using: :btree

  create_table "teams", force: true do |t|
    t.integer  "responsible_person_id"
    t.string   "responsible_person_title"
    t.text     "purpose"
    t.text     "win"
    t.string   "name"
    t.integer  "ministry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "deleted_at"
  end

  add_index "teams", ["deleted_at"], name: "index_teams_on_deleted_at", using: :btree
  add_index "teams", ["ministry_id"], name: "index_teams_on_ministry_id", using: :btree
  add_index "teams", ["responsible_person_id"], name: "index_teams_on_responsible_person_id", using: :btree

  create_table "tools", force: true do |t|
  end

  create_table "users", force: true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "encrypted_password",        limit: 128, default: "", null: false
    t.string   "password_salt",                         default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "group_scope"
    t.boolean  "is_staff"
    t.text     "preferences"
    t.datetime "remember_token_expires_at"
    t.string   "remember_token"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                       default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.integer  "person_id"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["person_id"], name: "index_users_on_person_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "web_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "created_by"
    t.string   "updated_by"
  end

  create_table "weekdays", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weekdays", ["name"], name: "index_weekdays_on_name", using: :btree

end
