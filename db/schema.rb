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

ActiveRecord::Schema.define(version: 20160802034414) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "lines", force: :cascade do |t|
    t.string   "RouteNo"
    t.string   "Direction"
    t.string   "Destination"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "Routes"
  end

  create_table "route_with_stops", force: :cascade do |t|
    t.integer  "stopID"
    t.integer  "routeID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stops", force: :cascade do |t|
    t.string   "Name"
    t.integer  "StopNo"
    t.decimal  "Latitude"
    t.decimal  "Longitude"
    t.string   "City"
    t.string   "AtStreet"
    t.string   "OnStreet"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "Routes"
    t.boolean  "WheelchairAccess"
  end

  create_table "students", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "widgets", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "stock"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
