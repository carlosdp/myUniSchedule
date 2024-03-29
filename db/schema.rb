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

ActiveRecord::Schema.define(:version => 20111118034935) do

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "weekdays"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "number"
    t.string   "section"
    t.integer  "school_id"
    t.integer  "semester_id"
  end

  create_table "courses_schedules", :id => false, :force => true do |t|
    t.integer "course_id"
    t.integer "schedule_id"
  end

  create_table "schedules", :force => true do |t|
    t.string   "vcal"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "website"
    t.boolean  "has_upload",      :default => false
    t.boolean  "has_link_upload", :default => false
  end

  create_table "semesters", :force => true do |t|
    t.string   "name"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "fbid"
    t.string   "name"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

end
