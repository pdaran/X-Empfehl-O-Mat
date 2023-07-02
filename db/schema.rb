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

ActiveRecord::Schema[7.0].define(version: 2023_07_02_140329) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
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

  create_table "attrs", force: :cascade do |t|
    t.string "name"
    t.string "unit"
    t.string "attrtype"
    t.bigint "numeric_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.uuid "category_id", null: false
    t.index ["numeric_category_id"], name: "index_attrs_on_numeric_category_id"
  end

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigserial "numeric_id", null: false
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.bigint "numeric_shop_id"
    t.uuid "shop_id", null: false
    t.index ["id"], name: "index_categories_on_id", unique: true
    t.index ["numeric_shop_id"], name: "index_categories_on_numeric_shop_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.boolean "like"
    t.bigint "customer_id", null: false
    t.bigint "numeric_product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "product_id", null: false
    t.index ["customer_id"], name: "index_likes_on_customer_id"
    t.index ["numeric_product_id"], name: "index_likes_on_numeric_product_id"
  end

  create_table "product_attrs", force: :cascade do |t|
    t.string "value"
    t.bigint "numeric_product_id"
    t.bigint "attr_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "float_val"
    t.uuid "product_id", null: false
    t.index ["attr_id"], name: "index_product_attrs_on_attr_id"
    t.index ["numeric_product_id", "attr_id"], name: "index_product_attrs_on_numeric_product_id_and_attr_id", unique: true
    t.index ["numeric_product_id"], name: "index_product_attrs_on_numeric_product_id"
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigserial "numeric_id", null: false
    t.string "product"
    t.text "desc"
    t.bigint "numeric_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.uuid "category_id", null: false
    t.index ["id"], name: "index_products_on_id", unique: true
    t.index ["numeric_category_id"], name: "index_products_on_numeric_category_id"
  end

  create_table "recommendations", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "numeric_product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "product_id", null: false
    t.index ["customer_id"], name: "index_recommendations_on_customer_id"
    t.index ["numeric_product_id"], name: "index_recommendations_on_numeric_product_id"
  end

  create_table "shops", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigserial "numeric_id", null: false
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.text "address"
    t.string "phone_no"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.index ["id"], name: "index_shops_on_id", unique: true
    t.index ["password_reset_token"], name: "index_shops_on_password_reset_token", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.boolean "shop", default: false
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.index ["password_reset_token"], name: "index_users_on_password_reset_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "attrs", "categories"
  add_foreign_key "categories", "shops"
  add_foreign_key "likes", "customers"
  add_foreign_key "likes", "products"
  add_foreign_key "product_attrs", "attrs"
  add_foreign_key "product_attrs", "products"
  add_foreign_key "products", "categories"
  add_foreign_key "recommendations", "customers"
  add_foreign_key "recommendations", "products"
end
