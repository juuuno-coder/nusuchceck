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

ActiveRecord::Schema[7.1].define(version: 2026_02_15_234107) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "escrow_transactions", force: :cascade do |t|
    t.bigint "request_id", null: false
    t.bigint "customer_id", null: false
    t.bigint "master_id", null: false
    t.decimal "amount", precision: 12, scale: 2, null: false
    t.decimal "platform_fee", precision: 10, scale: 2, default: "0.0"
    t.decimal "master_payout", precision: 10, scale: 2, default: "0.0"
    t.string "payment_method"
    t.string "pg_transaction_id"
    t.string "status", default: "pending"
    t.datetime "deposited_at"
    t.datetime "released_at"
    t.datetime "refunded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_escrow_transactions_on_customer_id"
    t.index ["master_id"], name: "index_escrow_transactions_on_master_id"
    t.index ["request_id"], name: "index_escrow_transactions_on_request_id", unique: true
  end

  create_table "estimates", force: :cascade do |t|
    t.bigint "request_id", null: false
    t.bigint "master_id", null: false
    t.jsonb "line_items", default: []
    t.decimal "detection_subtotal", precision: 10, scale: 2, default: "0.0"
    t.decimal "construction_subtotal", precision: 10, scale: 2, default: "0.0"
    t.decimal "material_subtotal", precision: 10, scale: 2, default: "0.0"
    t.decimal "vat", precision: 10, scale: 2, default: "0.0"
    t.decimal "total_amount", precision: 10, scale: 2, default: "0.0"
    t.string "status", default: "pending"
    t.text "notes"
    t.datetime "valid_until"
    t.datetime "accepted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["master_id"], name: "index_estimates_on_master_id"
    t.index ["request_id"], name: "index_estimates_on_request_id"
  end

  create_table "insurance_claims", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "request_id"
    t.string "status", default: "draft", null: false
    t.string "applicant_name", null: false
    t.string "applicant_phone", null: false
    t.string "applicant_email"
    t.date "birth_date"
    t.text "incident_address", null: false
    t.string "incident_detail_address"
    t.date "incident_date", null: false
    t.text "incident_description", null: false
    t.string "damage_type"
    t.decimal "estimated_damage_amount", precision: 12, scale: 2
    t.string "insurance_company"
    t.string "policy_number"
    t.string "insurance_type", default: "daily_liability"
    t.string "victim_name"
    t.string "victim_phone"
    t.text "victim_address"
    t.text "admin_notes"
    t.string "claim_number", null: false
    t.datetime "submitted_at"
    t.datetime "reviewed_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "prepared_by_master_id"
    t.boolean "customer_reviewed", default: false
    t.text "customer_review_notes"
    t.datetime "customer_reviewed_at"
    t.index ["claim_number"], name: "index_insurance_claims_on_claim_number", unique: true
    t.index ["customer_id"], name: "index_insurance_claims_on_customer_id"
    t.index ["prepared_by_master_id"], name: "index_insurance_claims_on_prepared_by_master_id"
    t.index ["request_id"], name: "index_insurance_claims_on_request_id"
    t.index ["status"], name: "index_insurance_claims_on_status"
  end

  create_table "leak_inspections", force: :cascade do |t|
    t.bigint "customer_id"
    t.string "status", default: "pending", null: false
    t.boolean "leak_detected", default: false
    t.string "severity"
    t.text "analysis_summary"
    t.jsonb "analysis_detail", default: {}
    t.text "recommended_action"
    t.string "location_description"
    t.integer "symptom_type"
    t.string "ai_model_used"
    t.integer "ai_tokens_used", default: 0
    t.float "analysis_duration_seconds"
    t.string "session_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_leak_inspections_on_customer_id"
    t.index ["session_token"], name: "index_leak_inspections_on_session_token", unique: true
    t.index ["status"], name: "index_leak_inspections_on_status"
  end

  create_table "master_profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "license_number"
    t.string "license_type"
    t.jsonb "equipment", default: []
    t.text "service_areas", default: [], array: true
    t.integer "experience_years", default: 0
    t.string "bank_name"
    t.string "account_number"
    t.string "account_holder"
    t.boolean "verified", default: false
    t.datetime "verified_at"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_master_profiles_on_user_id", unique: true
  end

  create_table "notifications", force: :cascade do |t|
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.string "actor_type"
    t.bigint "actor_id"
    t.string "notifiable_type"
    t.bigint "notifiable_id"
    t.string "action", null: false
    t.text "message"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_type", "actor_id"], name: "index_notifications_on_actor"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["recipient_type", "recipient_id", "created_at"], name: "idx_on_recipient_type_recipient_id_created_at_b03107666b"
    t.index ["recipient_type", "recipient_id", "read_at"], name: "idx_on_recipient_type_recipient_id_read_at_50191a301d"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient"
  end

  create_table "requests", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "master_id"
    t.string "status", default: "reported"
    t.integer "symptom_type", null: false
    t.integer "building_type", default: 0
    t.text "address", null: false
    t.string "detailed_address"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "floor_info"
    t.text "description"
    t.datetime "preferred_date"
    t.datetime "assigned_at"
    t.datetime "visit_started_at"
    t.datetime "detection_started_at"
    t.datetime "construction_started_at"
    t.datetime "construction_completed_at"
    t.datetime "closed_at"
    t.integer "detection_result"
    t.text "detection_notes"
    t.decimal "trip_fee", precision: 10, scale: 2, default: "0.0"
    t.decimal "detection_fee", precision: 10, scale: 2, default: "0.0"
    t.decimal "construction_fee", precision: 10, scale: 2, default: "0.0"
    t.decimal "total_fee", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_requests_on_customer_id"
    t.index ["master_id"], name: "index_requests_on_master_id"
    t.index ["status"], name: "index_requests_on_status"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "request_id", null: false
    t.bigint "customer_id", null: false
    t.bigint "master_id", null: false
    t.decimal "overall_rating", precision: 3, scale: 2, null: false
    t.integer "punctuality_rating"
    t.integer "skill_rating"
    t.integer "kindness_rating"
    t.integer "cleanliness_rating"
    t.integer "price_rating"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_reviews_on_customer_id"
    t.index ["master_id"], name: "index_reviews_on_master_id"
    t.index ["request_id"], name: "index_reviews_on_request_id", unique: true
  end

  create_table "standard_estimate_items", force: :cascade do |t|
    t.string "category", null: false
    t.string "name", null: false
    t.text "description"
    t.string "unit"
    t.decimal "min_price", precision: 10, scale: 2
    t.decimal "max_price", precision: 10, scale: 2
    t.decimal "default_price", precision: 10, scale: 2
    t.text "recommended_for", default: [], array: true
    t.integer "sort_order", default: 0
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "type"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.string "phone"
    t.text "address"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["type"], name: "index_users_on_type"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "escrow_transactions", "requests"
  add_foreign_key "escrow_transactions", "users", column: "customer_id"
  add_foreign_key "escrow_transactions", "users", column: "master_id"
  add_foreign_key "estimates", "requests"
  add_foreign_key "estimates", "users", column: "master_id"
  add_foreign_key "insurance_claims", "requests"
  add_foreign_key "insurance_claims", "users", column: "customer_id"
  add_foreign_key "insurance_claims", "users", column: "prepared_by_master_id"
  add_foreign_key "leak_inspections", "users", column: "customer_id"
  add_foreign_key "master_profiles", "users"
  add_foreign_key "requests", "users", column: "customer_id"
  add_foreign_key "requests", "users", column: "master_id"
  add_foreign_key "reviews", "requests"
  add_foreign_key "reviews", "users", column: "customer_id"
  add_foreign_key "reviews", "users", column: "master_id"
end
