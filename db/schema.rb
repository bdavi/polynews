# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_26_203436) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.string "guid", null: false
    t.bigint "channel_id", null: false
    t.text "content"
    t.datetime "published_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "url", null: false
    t.string "primary_image_url"
    t.string "thumbnail_image_url"
    t.text "scraped_content"
    t.bigint "group_id"
    t.index ["channel_id"], name: "index_articles_on_channel_id"
    t.index ["group_id"], name: "index_articles_on_group_id"
    t.index ["guid", "channel_id"], name: "index_articles_on_guid_and_channel_id", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "title", null: false
    t.integer "sort_order", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug", null: false
    t.index ["slug"], name: "index_categories_on_slug", unique: true
    t.index ["sort_order"], name: "index_categories_on_sort_order", unique: true
    t.index ["title"], name: "index_categories_on_title", unique: true
  end

  create_table "channels", force: :cascade do |t|
    t.string "title", null: false
    t.string "url", null: false
    t.datetime "last_build_date"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "image_url"
    t.string "scraping_content_selector"
    t.bigint "category_id"
    t.boolean "use_scraper", default: false, null: false
    t.index ["category_id"], name: "index_channels_on_category_id"
    t.index ["url"], name: "index_channels_on_url", unique: true
  end

  create_table "groups", force: :cascade do |t|
    t.bigint "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "cached_article_last_published_at"
    t.integer "cached_article_count", default: 0, null: false
    t.boolean "cached_has_primary_image"
    t.index ["category_id"], name: "index_groups_on_category_id"
  end

  add_foreign_key "articles", "channels"
  add_foreign_key "articles", "groups"
  add_foreign_key "channels", "categories"
  add_foreign_key "groups", "categories"
end
