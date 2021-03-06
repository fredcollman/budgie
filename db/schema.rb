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

ActiveRecord::Schema.define(version: 20160505194834) do

  create_table "entries", force: :cascade do |t|
    t.date    "date",                                 null: false
    t.text    "description",                          null: false
    t.decimal "amount",      precision: 8,  scale: 2, null: false
    t.decimal "balance",     precision: 10, scale: 2
  end

  create_table "entries_tags", id: false, force: :cascade do |t|
    t.integer "entry_id", null: false
    t.integer "tag_id",   null: false
  end

  add_index "entries_tags", ["entry_id", "tag_id"], name: "index_entries_tags_on_entry_id_and_tag_id", unique: true

  create_table "rules", force: :cascade do |t|
    t.string "name",           limit: 30, null: false
    t.text   "matching_regex"
    t.string "tag_name",       limit: 30
  end

  create_table "tags", force: :cascade do |t|
    t.string "name",        limit: 30, null: false
    t.text   "description"
  end

  add_index "tags", ["name"], name: "index_tags_on_name"

end
