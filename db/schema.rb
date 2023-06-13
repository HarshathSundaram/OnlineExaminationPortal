# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_06_13_080707) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "instructor_id"
    t.index ["instructor_id"], name: "index_courses_on_instructor_id"
  end

  create_table "instructors", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "gender"
    t.string "designation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "gender"
    t.string "department"
    t.string "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tests", force: :cascade do |t|
    t.string "testable_type", null: false
    t.bigint "testable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["testable_type", "testable_id"], name: "index_tests_on_testable"
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "courses_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["courses_id"], name: "index_topics_on_courses_id"
  end

  add_foreign_key "topics", "courses", column: "courses_id"
end
