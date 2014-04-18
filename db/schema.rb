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

ActiveRecord::Schema.define(version: 20140417223218) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: true do |t|
    t.string   "name",                    null: false
    t.string   "musicbrainz_uuid"
    t.string   "lastfm_url"
    t.string   "lastfm_image_small"
    t.string   "lastfm_image_medium"
    t.string   "lastfm_image_large"
    t.string   "lastfm_image_extralarge"
    t.string   "lastfm_image_mega"
    t.string   "tags",                                 array: true
    t.string   "lastfm_summary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "lastfm_uuid"
    t.string   "title",                                null: false
    t.text     "lastfm_description"
    t.string   "lastfm_url",              limit: 1024
    t.string   "website",                 limit: 1024
    t.string   "venue_name"
    t.string   "venue_latitude",                       null: false
    t.string   "venue_longitude",                      null: false
    t.string   "venue_city"
    t.string   "venue_country"
    t.string   "venue_street"
    t.string   "venue_postalcode"
    t.string   "venue_url"
    t.datetime "starts_at",                            null: false
    t.datetime "ends_at"
    t.string   "lastfm_image_small"
    t.string   "lastfm_image_medium"
    t.string   "lastfm_image_large"
    t.string   "lastfm_image_extralarge"
    t.string   "poster",                               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["title"], name: "index_events_on_title", using: :btree

  create_table "performances", force: true do |t|
    t.integer  "artist_id"
    t.integer  "event_id"
    t.boolean  "headliner",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "performances", ["artist_id", "event_id", "headliner"], name: "index_performances_on_artist_id_and_event_id_and_headliner", unique: true, using: :btree
  add_index "performances", ["artist_id"], name: "index_performances_on_artist_id", using: :btree
  add_index "performances", ["event_id", "headliner"], name: "index_performances_on_event_id_and_headliner", using: :btree
  add_index "performances", ["event_id"], name: "index_performances_on_event_id", using: :btree

  create_table "recordings", force: true do |t|
    t.integer  "track_id",    null: false
    t.integer  "artist_id",   null: false
    t.string   "youtube_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recordings", ["artist_id"], name: "index_recordings_on_artist_id", using: :btree
  add_index "recordings", ["track_id", "artist_id"], name: "index_recordings_on_track_id_and_artist_id", unique: true, using: :btree
  add_index "recordings", ["track_id"], name: "index_recordings_on_track_id", using: :btree

  create_table "tracks", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tracks", ["name"], name: "index_tracks_on_name", unique: true, using: :btree

end
