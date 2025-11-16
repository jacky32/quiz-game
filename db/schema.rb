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

ActiveRecord::Schema[8.1].define(version: 2025_11_16_145200) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "playthroughs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "score", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_playthroughs_on_user_id"
  end

  create_table "playthroughs_questions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "fifty_hint_question_option1_id"
    t.integer "fifty_hint_question_option2_id"
    t.boolean "fifty_hint_used"
    t.integer "playthrough_id", null: false
    t.integer "question_id", null: false
    t.boolean "question_swap_used"
    t.integer "selected_question_option_id"
    t.integer "status", default: 0, null: false
    t.integer "swapped_question_id"
    t.boolean "text_hint_used"
    t.datetime "updated_at", null: false
    t.index ["fifty_hint_question_option1_id"], name: "index_playthroughs_questions_on_fifty_hint_question_option1_id"
    t.index ["fifty_hint_question_option2_id"], name: "index_playthroughs_questions_on_fifty_hint_question_option2_id"
    t.index ["playthrough_id"], name: "index_playthroughs_questions_on_playthrough_id"
    t.index ["question_id"], name: "index_playthroughs_questions_on_question_id"
    t.index ["selected_question_option_id"], name: "index_playthroughs_questions_on_selected_question_option_id"
    t.index ["swapped_question_id"], name: "index_playthroughs_questions_on_swapped_question_id"
  end

  create_table "question_options", force: :cascade do |t|
    t.boolean "correct", default: false, null: false
    t.datetime "created_at", null: false
    t.integer "question_id", null: false
    t.string "text", null: false
    t.datetime "updated_at", null: false
    t.string "uuid", null: false
    t.index ["question_id"], name: "index_question_options_on_question_id"
    t.index ["uuid"], name: "index_question_options_on_uuid"
  end

  create_table "questions", force: :cascade do |t|
    t.boolean "active", default: false, null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.integer "creator_id", null: false
    t.text "hint", null: false
    t.integer "level", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_questions_on_creator_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "playthroughs", "users"
  add_foreign_key "playthroughs_questions", "playthroughs"
  add_foreign_key "playthroughs_questions", "question_options", column: "fifty_hint_question_option1_id"
  add_foreign_key "playthroughs_questions", "question_options", column: "fifty_hint_question_option2_id"
  add_foreign_key "playthroughs_questions", "question_options", column: "selected_question_option_id"
  add_foreign_key "playthroughs_questions", "questions"
  add_foreign_key "playthroughs_questions", "questions", column: "swapped_question_id"
  add_foreign_key "question_options", "questions"
  add_foreign_key "questions", "users", column: "creator_id"
  add_foreign_key "sessions", "users"
end
