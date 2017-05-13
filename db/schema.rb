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

ActiveRecord::Schema.define(version: 20170513192311) do

  create_table "admin_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",               default: "", null: false
    t.string   "encrypted_password",  default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  end

  create_table "calendar_posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title_en"
    t.string   "title_cn"
    t.date     "release_date"
    t.string   "cover_image"
    t.decimal  "usd",          precision: 10
    t.decimal  "rmb",          precision: 10
    t.integer  "release_type",                default: 0, null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "feature_posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title_en"
    t.text     "content_en",  limit: 65535
    t.string   "main_image"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "title_cn"
    t.string   "cover_image"
    t.text     "content_cn",  limit: 65535
  end

  create_table "on_court_posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title_en"
    t.text     "content_en",     limit: 65535
    t.string   "cover_image"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "title_cn"
    t.string   "main_image"
    t.text     "content_cn",     limit: 65535
    t.string   "player_name_en"
    t.string   "player_name_cn"
  end

  create_table "posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "post_type",    default: 0, null: false
    t.string   "title_en"
    t.string   "image"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "pointer_type", default: 0, null: false
    t.integer  "pointer_id"
    t.string   "title_cn"
  end

  create_table "trend_posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title_en"
    t.text     "content_en",  limit: 65535
    t.string   "main_image"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "title_cn"
    t.string   "cover_image"
    t.text     "content_cn",  limit: 65535
  end

end
