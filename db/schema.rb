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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130407065756) do

  create_table "action_plan_comments", :force => true do |t|
    t.integer  "action_plan_id"
    t.text     "content"
    t.integer  "user_id"
    t.boolean  "log_comment",    :default => false
    t.boolean  "boolean",        :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "action_plan_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "action_plans", :force => true do |t|
    t.text     "description"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.integer  "ap_reviewer_id"
    t.date     "final_review_date"
    t.integer  "implementation_reviewer_id"
    t.date     "final_implementation_review_date"
    t.integer  "issue_id"
    t.integer  "responsible_officer_id"
    t.boolean  "approved",                         :default => false
    t.boolean  "implemented",                      :default => false
    t.integer  "ap_status_id"
  end

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.date     "target_date"
    t.date     "actual_date"
    t.text     "result"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "action_plan_id"
    t.integer  "status_id"
  end

  create_table "activity_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cause_attachments", :force => true do |t|
    t.string   "description"
    t.integer  "cause_id"
    t.string   "myfile"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "cause_comments", :force => true do |t|
    t.integer  "cause_id"
    t.text     "content"
    t.integer  "user_id"
    t.boolean  "log_comment", :default => false
    t.boolean  "boolean",     :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "causes", :force => true do |t|
    t.text     "description"
    t.date     "date_issued"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "issue_id"
  end

  create_table "closeout_form_depts", :force => true do |t|
    t.integer  "dept_id"
    t.integer  "dept_head_id"
    t.integer  "officer_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "closeout_form_id"
  end

  create_table "closeout_forms", :force => true do |t|
    t.integer  "auditor_id"
    t.integer  "issue_id"
    t.integer  "qmr_id"
    t.boolean  "completed",     :default => false
    t.boolean  "boolean",       :default => false
    t.date     "closeout_date"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "iso_ncs", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "issue_attachments", :force => true do |t|
    t.string   "myfile"
    t.string   "description"
    t.integer  "user_id"
    t.integer  "issue_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "issue_comments", :force => true do |t|
    t.integer  "issue_id"
    t.text     "content"
    t.integer  "user_id"
    t.boolean  "log_comment", :default => false
    t.boolean  "boolean",     :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "issue_impacts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "issue_statuses", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "issue_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "issues", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "type_id"
    t.integer  "department_id"
    t.integer  "impact_id"
    t.integer  "iso_nc_id"
    t.integer  "status_id"
    t.integer  "cause_id"
    t.integer  "action_plan_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "responsible_officer_id"
    t.date     "estimated_closeout_date"
    t.date     "final_closeout_date"
  end

  create_table "next_responsible_departments", :force => true do |t|
    t.integer  "issue_id"
    t.integer  "department_id"
    t.integer  "responsible_officer_id"
    t.integer  "dept_status_id"
    t.integer  "responsibility_level"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "user_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.integer  "type_id"
    t.string   "phone"
    t.string   "mobile"
    t.string   "email"
    t.integer  "department_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",                  :default => false
    t.boolean  "with_role",              :default => false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "verification_token"
    t.datetime "verification_sent_at"
    t.boolean  "verified",               :default => false
    t.boolean  "account_enabled",        :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
