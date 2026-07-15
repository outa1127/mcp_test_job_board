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

ActiveRecord::Schema[8.1].define(version: 2026_07_15_072433) do
  create_table "companies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "employee_count"
    t.string "industry"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "job_postings", force: :cascade do |t|
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "remote_ok"
    t.integer "salary_max"
    t.integer "salary_min"
    t.string "tech_stack"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_job_postings_on_company_id"
  end

  add_foreign_key "job_postings", "companies"
end
