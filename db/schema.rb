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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141208134739) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vote_count",  default: 0, null: false
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "authorizations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.text     "uid"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "post_id"
    t.string   "post_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["post_type", "post_id"], name: "index_comments_on_post_type_and_post_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vote_count",          default: 0, null: false
    t.integer  "last_active_user_id"
    t.datetime "last_active_at"
    t.integer  "answers_count",       default: 0, null: false
    t.integer  "accepted_answer_id"
  end

  create_table "reputation_events", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_type"
    t.string   "action_type"
    t.integer  "action_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reputation_events", ["user_id"], name: "index_reputation_events_on_user_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["question_id"], name: "index_taggings_on_question_id", using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timeline_actors", force: :cascade do |t|
    t.integer  "timeline_event_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timeline_actors", ["timeline_event_id"], name: "index_timeline_actors_on_timeline_event_id", using: :btree
  add_index "timeline_actors", ["user_id"], name: "index_timeline_actors_on_user_id", using: :btree

  create_table "timeline_events", force: :cascade do |t|
    t.integer  "post_id"
    t.string   "post_type"
    t.integer  "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",      default: false, null: false
    t.integer  "reputation", default: 0,     null: false
    t.text     "about_me",   default: "",    null: false
    t.boolean  "moderator",  default: false, null: false
    t.string   "location",   default: "",    null: false
    t.string   "website",    default: "",    null: false
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "vote_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "post_type"
  end

  add_index "votes", ["post_type", "post_id"], name: "index_votes_on_post_type_and_post_id", using: :btree

end
