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

ActiveRecord::Schema[8.1].define(version: 2026_05_02_210712) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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

  create_table "certifications", force: :cascade do |t|
    t.date "certified_at"
    t.datetime "created_at", null: false
    t.string "name_en"
    t.string "name_pt"
    t.integer "position"
    t.string "provider"
    t.datetime "updated_at", null: false
    t.string "url"
  end

  create_table "educations", force: :cascade do |t|
    t.json "activities_en"
    t.json "activities_pt"
    t.string "course_en"
    t.string "course_pt"
    t.datetime "created_at", null: false
    t.string "degree_en"
    t.string "degree_pt"
    t.date "ended_at"
    t.string "institution"
    t.integer "position"
    t.date "started_at"
    t.datetime "updated_at", null: false
  end

  create_table "experiences", force: :cascade do |t|
    t.json "achievements_en"
    t.json "achievements_pt"
    t.string "company"
    t.string "company_url"
    t.datetime "created_at", null: false
    t.text "description_en"
    t.text "description_pt"
    t.date "ended_at"
    t.integer "position"
    t.string "role_en"
    t.string "role_pt"
    t.date "started_at"
    t.json "technologies"
    t.datetime "updated_at", null: false
  end

  create_table "languages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "level_en"
    t.string "level_pt"
    t.string "name_en"
    t.string "name_pt"
    t.integer "position"
    t.string "proficiency"
    t.datetime "updated_at", null: false
  end

  create_table "personal_infos", force: :cascade do |t|
    t.json "bio_en"
    t.json "bio_pt"
    t.datetime "created_at", null: false
    t.string "email"
    t.text "footer_text_en"
    t.text "footer_text_pt"
    t.string "location"
    t.string "name"
    t.string "phone"
    t.text "tagline_en"
    t.text "tagline_pt"
    t.string "title"
    t.datetime "updated_at", null: false
    t.text "whatsapp_message"
  end

  create_table "posts", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description_en"
    t.text "description_pt"
    t.string "locale"
    t.boolean "published"
    t.datetime "published_at"
    t.integer "reading_time"
    t.string "slug"
    t.json "tags"
    t.string "title_en"
    t.string "title_pt"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description_en"
    t.text "description_pt"
    t.date "ended_at"
    t.string "github_url"
    t.string "name"
    t.integer "position"
    t.date "started_at"
    t.json "technologies"
    t.datetime "updated_at", null: false
    t.string "url"
  end

  create_table "skills", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.boolean "featured"
    t.string "name"
    t.integer "position"
    t.string "proficiency"
    t.datetime "updated_at", null: false
  end

  create_table "social_links", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "icon"
    t.string "label"
    t.integer "personal_info_id", null: false
    t.string "platform"
    t.integer "position"
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["personal_info_id"], name: "index_social_links_on_personal_info_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.datetime "updated_at", null: false
  end

  create_table "volunteerings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "ended_at"
    t.string "organization"
    t.integer "position"
    t.string "role_en"
    t.string "role_pt"
    t.date "started_at"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "posts", "users"
  add_foreign_key "social_links", "personal_infos"
end
