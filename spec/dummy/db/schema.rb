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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120424075531) do

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "simple_forum_categories", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.integer  "position",   :default => 0
    t.string   "slug_cache"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "simple_forum_categories", ["slug_cache"], :name => "index_simple_forum_categories_on_slug_cache"

  create_table "simple_forum_forums", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.integer  "position",       :default => 0
    t.boolean  "is_topicable",   :default => true
    t.integer  "recent_post_id"
    t.integer  "category_id"
    t.integer  "topics_count",   :default => 0
    t.integer  "posts_count",    :default => 0
    t.string   "slug_cache"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "simple_forum_forums", ["category_id"], :name => "index_simple_forum_forums_on_category_id"
  add_index "simple_forum_forums", ["slug_cache"], :name => "index_simple_forum_forums_on_slug_cache"

  create_table "simple_forum_moderatorships", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "simple_forum_moderatorships", ["forum_id"], :name => "index_simple_forum_moderatorships_on_forum_id"
  add_index "simple_forum_moderatorships", ["user_id"], :name => "index_simple_forum_moderatorships_on_user_id"

  create_table "simple_forum_posts", :force => true do |t|
    t.integer  "topic_id"
    t.integer  "forum_id"
    t.integer  "user_id"
    t.text     "body"
    t.integer  "deleted_by_id"
    t.datetime "deleted_at"
    t.integer  "edited_by_id"
    t.datetime "edited_at"
    t.string   "slug_cache"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "simple_forum_posts", ["deleted_by_id"], :name => "index_simple_forum_posts_on_deleted_by_id"
  add_index "simple_forum_posts", ["edited_by_id"], :name => "index_simple_forum_posts_on_edited_by_id"
  add_index "simple_forum_posts", ["forum_id"], :name => "index_simple_forum_posts_on_forum_id"
  add_index "simple_forum_posts", ["slug_cache"], :name => "index_simple_forum_posts_on_slug_cache"
  add_index "simple_forum_posts", ["topic_id"], :name => "index_simple_forum_posts_on_topic_id"
  add_index "simple_forum_posts", ["user_id"], :name => "index_simple_forum_posts_on_user_id"

  create_table "simple_forum_topics", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "title"
    t.boolean  "is_closed",       :default => false
    t.integer  "recent_post_id"
    t.datetime "last_updated_at"
    t.integer  "posts_count",     :default => 0
    t.integer  "views_count",     :default => 0
    t.string   "slug_cache"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "simple_forum_topics", ["forum_id"], :name => "index_simple_forum_topics_on_forum_id"
  add_index "simple_forum_topics", ["last_updated_at"], :name => "index_simple_forum_topics_on_last_updated_at"
  add_index "simple_forum_topics", ["slug_cache"], :name => "index_simple_forum_topics_on_slug_cache"
  add_index "simple_forum_topics", ["user_id"], :name => "index_simple_forum_topics_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",              :default => "", :null => false
    t.string   "encrypted_password", :default => "", :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

end
